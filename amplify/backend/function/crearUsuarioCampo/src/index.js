const {
  CognitoIdentityProviderClient,
  AdminCreateUserCommand,
  AdminGetUserCommand,
  AdminDeleteUserCommand,
  AdminUpdateUserAttributesCommand,
  ListUsersCommand,
} = require('@aws-sdk/client-cognito-identity-provider');
const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');
const { CognitoJwtVerifier } = require('aws-jwt-verify');

const cognito = new CognitoIdentityProviderClient({});
// SES debe apuntar a la región donde el dominio/correo está verificado.
const ses = new SESClient({ region: process.env.SES_REGION || 'us-east-1' });

const ROLES_PERMITIDOS_CREAR = new Set(['lider_cuadrilla', 'operador']);
const ROL_LIDER_PROYECTO = 'lider_proyecto';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type,Authorization',
  'Access-Control-Allow-Methods': 'POST,OPTIONS',
  'Access-Control-Max-Age': '86400',
};

const jsonResponse = (statusCode, body) => ({
  statusCode,
  headers: {
    ...corsHeaders,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(body),
});

const getBearerToken = (headers = {}) => {
  const auth =
    headers.authorization ||
    headers.Authorization ||
    headers.AUTHORIZATION ||
    '';
  if (!auth.startsWith('Bearer ')) {
    return null;
  }
  return auth.slice(7).trim();
};

let jwtVerifier;

const getJwtVerifier = () => {
  if (!jwtVerifier) {
    jwtVerifier = CognitoJwtVerifier.create({
      userPoolId: process.env.USER_POOL_ID,
      tokenUse: 'id',
      clientId: process.env.USER_POOL_CLIENT_ID,
    });
  }
  return jwtVerifier;
};

const generateTemporaryPassword = () => {
  const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  const lower = 'abcdefghjkmnpqrstuvwxyz';
  const digits = '23456789';
  const special = '!@#$%&*';
  const all = upper + lower + digits + special;

  const pick = (chars) => chars[Math.floor(Math.random() * chars.length)];

  const required = [pick(upper), pick(lower), pick(digits), pick(special)];
  const rest = Array.from({ length: 8 }, () => pick(all));

  return [...required, ...rest]
    .sort(() => Math.random() - 0.5)
    .join('');
};

const buildUserMetadata = ({
  email,
  rol,
  mediciones,
  activo,
  departamentoUbicacion,
  municipioUbicacion,
}) =>
  JSON.stringify({
    email,
    rol,
    mediciones: mediciones || [],
    activo: activo !== false,
    departamentoUbicacion: departamentoUbicacion || null,
    municipioUbicacion: municipioUbicacion || null,
  });

const parseUserMetadata = (municipio) => {
  if (!municipio) {
    return { email: null, rol: null, mediciones: [], activo: true };
  }
  try {
    const parsed = JSON.parse(municipio);
    return {
      email: parsed.email || null,
      rol: parsed.rol || null,
      mediciones: Array.isArray(parsed.mediciones) ? parsed.mediciones : [],
      activo: parsed.activo !== false,
    };
  } catch {
    return { email: null, rol: null, mediciones: [], activo: true };
  }
};

const graphqlRequest = async (query, variables) => {
  const endpoint = process.env.APPSYNC_ENDPOINT;
  const apiKey = process.env.APPSYNC_API_KEY;

  if (!endpoint || !apiKey) {
    throw new Error('AppSync no configurado en la Lambda');
  }

  const response = await fetch(endpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    },
    body: JSON.stringify({ query, variables }),
  });

  const payload = await response.json();

  if (payload.errors?.length) {
    throw new Error(payload.errors.map((e) => e.message).join('; '));
  }

  return payload.data;
};

const createUserRecord = async ({ id, nombre, metadata }) => {
  const mutation = `
    mutation CreateUser($input: CreateUserInput!) {
      createUser(input: $input) {
        id
        departamento
        municipio
      }
    }
  `;

  const data = await graphqlRequest(mutation, {
    input: {
      id,
      departamento: nombre,
      municipio: metadata,
    },
  });

  return data.createUser;
};

const getUserRecord = async (id) => {
  const query = `
    query GetUser($id: ID!) {
      getUser(id: $id) {
        id
        departamento
        municipio
      }
    }
  `;

  const data = await graphqlRequest(query, { id });
  return data.getUser;
};

const updateUserRecord = async ({ id, nombre, metadata }) => {
  const mutation = `
    mutation UpdateUser($input: UpdateUserInput!) {
      updateUser(input: $input) {
        id
        departamento
        municipio
      }
    }
  `;

  const data = await graphqlRequest(mutation, {
    input: {
      id,
      departamento: nombre,
      municipio: metadata,
    },
  });

  return data.updateUser;
};

const resolveCognitoUsername = async ({ email, userId }) => {
  const userPoolId = process.env.USER_POOL_ID;

  if (email) {
    try {
      const userInfo = await cognito.send(
        new AdminGetUserCommand({
          UserPoolId: userPoolId,
          Username: email,
        }),
      );
      return userInfo.Username || email;
    } catch (error) {
      console.warn('AdminGetUser por email falló, intentando por sub:', error.message);
    }
  }

  if (userId) {
    const listed = await cognito.send(
      new ListUsersCommand({
        UserPoolId: userPoolId,
        Filter: `sub = "${userId}"`,
        Limit: 1,
      }),
    );
    const found = listed.Users?.[0];
    if (found?.Username) {
      return found.Username;
    }
  }

  return null;
};

const listUserRecords = async () => {
  const query = `
    query ListUsers($limit: Int, $nextToken: String) {
      listUsers(limit: $limit, nextToken: $nextToken) {
        items {
          id
          departamento
          municipio
        }
        nextToken
      }
    }
  `;

  const items = [];
  let nextToken = null;

  do {
    const data = await graphqlRequest(query, { limit: 200, nextToken });
    const page = data.listUsers;
    items.push(...(page.items || []));
    nextToken = page.nextToken;
  } while (nextToken);

  return items;
};

// ── Plantilla HTML con marca Terrasacha ──────────────────────────────────────

const LOGO_SVG = `<svg xmlns="http://www.w3.org/2000/svg" width="220" height="54" viewBox="0 0 2435 598.36" style="display:block;"><defs><style>.fil0{fill:#ffffff;fill-rule:nonzero;}</style></defs><g><path class="fil0" d="M792.43 161.4l-181.96 0c9.37,18.55 17.13,38.26 22.95,59.04 0.22,0.76 0.38,1.52 0.58,2.28l44.32 0 0 208.1 66.08 0 0 -208.1 63.98 0 -15.95 -61.32z"/><path class="fil0" d="M902.98 302.37c-4.17,-4.92 -8.52,-8.9 -13.25,-11.74 -7.38,-4.35 -15.34,-6.44 -23.85,-6.44 -8.52,0 -16.47,2.09 -23.86,6.44 -4.73,2.84 -9.08,6.82 -13.25,11.74l74.21 0zm3.03 -65.31c12.87,5.11 24.23,12.3 34.26,21.58 10.04,9.27 17.79,20.25 23.47,33.13 5.68,12.68 8.52,26.31 8.52,40.89l0 2.65 -0.18 1.13 -0.38 3.22 -23.48 0 0 0.38 -130.24 0c1.52,10.6 6.06,19.69 13.82,27.45 9.66,9.65 21.02,14.38 34.08,14.38 13.06,0 24.42,-4.73 34.07,-14.38l0.38 -0.38 0.57 -0.76 0.57 -0.57 0.37 -0.57 32.56 46.57c-9.08,7.39 -18.55,13.25 -28.39,17.23 -12.68,5.11 -26.13,7.57 -40.13,7.57 -18.74,0 -36.35,-4.54 -52.44,-13.44 -16.47,-9.09 -29.53,-21.58 -39.18,-37.29 -9.85,-15.71 -14.77,-33.51 -14.77,-53.19 0,-14.77 2.84,-28.4 8.52,-40.89 5.67,-12.69 13.44,-23.67 23.47,-32.94 10.03,-9.66 21.39,-16.85 34.07,-21.77 12.88,-5.11 26.32,-7.57 40.33,-7.57 14,0 27.45,2.46 40.13,7.57z"/><path class="fil0" d="M1081.11 287.6c-3.41,-2.27 -7.57,-3.41 -12.3,-3.59l-3.41 0c-15.33,0.56 -23.09,11.35 -23.09,32.18l0 114.71 -60.58 0 0 -114.71c0,-55.09 27.83,-84.05 83.67,-86.89l3.41 0c4.35,0.19 8.33,0.56 12.3,1.13l0 57.17z"/><path class="fil0" d="M1189.96 287.6c-3.41,-2.27 -7.57,-3.41 -12.3,-3.59l-3.41 0c-15.33,0.56 -23.1,11.35 -23.1,32.18l0 114.71 -60.57 0 0 -114.71c0,-55.09 27.83,-84.05 83.67,-86.89l3.41 0c4.35,0.19 8.33,0.56 12.3,1.13l0 57.17z"/><path class="fil0" d="M1310.36 284.19c-8.9,0 -17.04,2.09 -24.8,6.44 -7.57,4.36 -13.82,10.22 -18.74,17.8 -4.74,7.38 -7.01,15.52 -7.01,24.42 0,13.43 5.12,24.98 15.15,34.64 10.03,9.65 21.77,14.38 35.4,14.38 13.82,0 25.55,-4.73 35.59,-14.38 10.03,-9.66 15.14,-21.21 15.14,-34.64 0,-8.9 -2.27,-17.04 -7.01,-24.42 -4.92,-7.58 -11.16,-13.44 -18.74,-17.8 -7.75,-4.35 -16.09,-6.44 -24.98,-6.44zm50.92 141.04c-4.73,2.07 -7.76,3.21 -8.9,3.59 -13.63,5.11 -27.64,7.76 -42.02,7.76 -19.12,0 -37.49,-4.54 -54.71,-13.44 -17.23,-9.08 -30.86,-21.39 -40.89,-37.1 -10.22,-15.9 -15.34,-33.7 -15.34,-53.19 0,-14.58 3.03,-28.4 8.9,-41.27 5.87,-12.69 14.01,-23.66 24.42,-32.94 10.42,-9.28 22.15,-16.47 35.59,-21.39 13.63,-5.11 27.64,-7.77 42.03,-7.77 14.57,0 28.58,2.47 42.02,7.58 13.82,5.11 25.56,12.3 35.59,21.58 10.41,9.65 18.74,20.63 24.61,32.94 5.87,12.87 8.9,26.69 8.9,41.27l-0.19 98.62 -60.01 -0.57 0 -5.67z"/><path class="fil0" d="M1461.61 369.95c11.92,11.92 26.69,17.98 43.92,17.98 17.98,0 27.07,-5.3 27.07,-15.9 0,-5.49 -4.92,-9.65 -14.96,-12.3 -9.08,-2.09 -20.25,-4.93 -33.7,-8.52 -12.68,-3.22 -23.09,-9.28 -31.61,-18.18 -8.52,-8.51 -12.68,-21.95 -12.68,-40.13 0,-13.82 3.41,-25.55 10.41,-35.21 7.01,-9.46 16.09,-16.47 27.45,-21.2 11.36,-4.73 23.85,-7 37.67,-7 7.38,0 15.33,1.13 23.48,3.21 8.89,2.85 16.47,6.06 23.09,9.85 7.38,4.16 13.82,8.89 19.69,14.01l-33.32 33.12c-9.66,-7.38 -20.26,-10.97 -31.8,-10.97 -13.82,0 -20.64,3.78 -20.64,11.54 0,6.82 5.12,11.74 15.33,14.58 10.8,2.84 21.97,5.68 33.89,8.52 12.68,3.21 23.1,9.08 31.24,17.41 8.51,8.52 12.68,21.96 12.68,40.51 0,13.82 -3.6,25.56 -10.98,35.59 -7.38,10.22 -17.23,17.8 -29.34,22.53 -12.49,5.11 -25.18,7.76 -38.05,7.76 -10.6,0 -20.45,-0.95 -29.72,-2.65 -9.09,-1.71 -17.42,-4.54 -24.8,-8.33 -8.52,-4.17 -16.85,-9.47 -24.99,-15.71l30.67 -40.51z"/><path class="fil0" d="M1709.21 284.19c-8.89,0 -17.03,2.09 -24.79,6.44 -7.57,4.36 -13.82,10.22 -18.74,17.8 -4.74,7.38 -7.01,15.52 -7.01,24.42 0,13.43 5.11,24.98 15.15,34.64 10.03,9.65 21.77,14.38 35.39,14.38 13.83,0 25.56,-4.73 35.6,-14.38 10.03,-9.66 15.14,-21.21 15.14,-34.64 0,-8.9 -2.27,-17.04 -7.01,-24.42 -4.92,-7.58 -11.16,-13.44 -18.74,-17.8 -7.76,-4.35 -16.09,-6.44 -24.99,-6.44zm50.93 141.04c-4.74,2.07 -7.76,3.21 -8.9,3.59 -13.63,5.11 -27.64,7.76 -42.03,7.76 -19.12,0 -37.48,-4.54 -54.7,-13.44 -17.23,-9.08 -30.86,-21.39 -40.89,-37.1 -10.22,-15.9 -15.34,-33.7 -15.34,-53.19 0,-14.58 3.03,-28.4 8.9,-41.27 5.87,-12.69 14.01,-23.66 24.42,-32.94 10.41,-9.28 22.15,-16.47 35.59,-21.39 13.63,-5.11 27.64,-7.77 42.02,-7.77 14.58,0 28.59,2.47 42.03,7.58 13.82,5.11 25.56,12.3 35.59,21.58 10.41,9.65 18.74,20.63 24.61,32.94 5.87,12.87 8.9,26.69 8.9,41.27l-0.19 98.62 -60.01 -0.57 0 -5.67z"/><path class="fil0" d="M1978.97 295.55c-5.49,-4.54 -11.55,-7.95 -17.79,-10.22 -6.63,-2.27 -13.63,-3.41 -21.2,-3.41 -13.82,0 -25.56,4.54 -35.21,13.44 -9.66,8.9 -14.58,20.07 -14.58,33.32 0,10.41 2.08,19.69 6.25,27.83 3.97,8.14 10.03,14.76 17.98,19.5 7.76,4.92 16.66,7.38 26.69,7.38 14.95,0 27.64,-4.73 38.24,-14.2l33.13 42.02c-4.36,4.74 -11.17,9.28 -20.07,13.44 -8.52,3.98 -17.41,6.82 -26.88,8.71 -9.28,1.9 -17.8,2.84 -25.55,2.84 -21.97,0 -41.27,-4.54 -58.12,-13.82 -16.85,-9.27 -29.72,-21.39 -38.62,-36.72 -8.9,-15.33 -13.44,-31.8 -13.44,-49.41 0,-16.09 2.65,-30.67 8.14,-43.54 5.49,-13.06 13.06,-24.42 22.91,-34.07 9.65,-9.28 21.2,-16.47 35.02,-21.77 13.82,-5.11 28.39,-7.76 44.11,-7.76 12.68,0 25.17,2.08 37.67,6.05 12.3,4.17 23.28,10.04 32.74,17.61l-31.42 42.78z"/><path class="fil0" d="M2082.52 162.09l0 86.33c5.87,-5.87 13.06,-10.6 21.58,-14.01 8.71,-3.41 17.6,-5.11 26.5,-5.11 48.65,0 72.88,28.39 72.88,85.37l0 116.23 -60.57 0.19 0 -112.25c0,-11.55 -2.66,-20.26 -7.96,-26.13 -5.3,-5.87 -12.68,-8.71 -22.33,-8.71 -9.28,0 -16.66,2.84 -21.96,8.71 -5.49,5.87 -8.14,14.58 -8.14,26.13l0 112.06 -60.58 0.38 0 -269 60.58 -0.19z"/><path class="fil0" d="M2323.88 284.19c-8.9,0 -17.04,2.09 -24.8,6.44 -7.57,4.36 -13.82,10.22 -18.74,17.8 -4.73,7.38 -7.01,15.52 -7.01,24.42 0,13.43 5.12,24.98 15.15,34.64 10.03,9.65 21.77,14.38 35.4,14.38 13.82,0 25.56,-4.73 35.59,-14.38 10.03,-9.66 15.14,-21.21 15.14,-34.64 0,-8.9 -2.27,-17.04 -7,-24.42 -4.92,-7.58 -11.17,-13.44 -18.75,-17.8 -7.75,-4.35 -16.09,-6.44 -24.98,-6.44zm50.92 141.04c-4.73,2.07 -7.76,3.21 -8.9,3.59 -13.63,5.11 -27.64,7.76 -42.02,7.76 -19.12,0 -37.48,-4.54 -54.71,-13.44 -17.23,-9.08 -30.86,-21.39 -40.89,-37.1 -10.22,-15.9 -15.33,-33.7 -15.33,-53.19 0,-14.58 3.03,-28.4 8.9,-41.27 5.86,-12.69 14,-23.66 24.41,-32.94 10.42,-9.28 22.15,-16.47 35.6,-21.39 13.62,-5.11 27.63,-7.77 42.02,-7.77 14.57,0 28.58,2.47 42.02,7.58 13.82,5.11 25.56,12.3 35.59,21.58 10.41,9.65 18.74,20.63 24.61,32.94 5.87,12.87 8.9,26.69 8.9,41.27l-0.19 98.62 -60.01 -0.57 0 -5.67z"/><path class="fil0" d="M481.72 129.35c53.79,56.82 75.22,132.52 64.97,204.39 -0.72,6.02 -1.76,11.94 -3.18,17.71 -0.08,0.37 -0.15,0.76 -0.23,1.13 0.01,-0.13 0.02,-0.27 0.04,-0.41 -15.83,62.82 -72.33,109.65 -140.15,110.42 -80.77,0.92 -146.99,-63.81 -147.9,-144.58 -0.93,-80.76 63.8,-146.98 144.57,-147.9 48.74,-0.55 92.15,22.82 119.14,59.18 -8.64,-15.97 -19.48,-31.09 -32.56,-44.91 -80.5,-85.05 -214.71,-88.73 -299.76,-8.22 -85.05,80.5 -88.74,214.72 -8.23,299.77 44.37,46.87 105.06,69.02 164.83,65.98 -78.1,12.95 -161.01,-11.88 -219.53,-73.7 -93.57,-98.85 -89.29,-254.85 9.57,-348.43 98.85,-93.57 254.85,-89.29 348.42,9.57zm-263.25 -118.18c-159.06,44.58 -251.87,209.65 -207.3,368.71 44.57,159.07 209.65,251.88 368.71,207.3 159.06,-44.57 251.88,-209.65 207.3,-368.71 -44.57,-159.06 -209.65,-251.87 -368.71,-207.3z"/></g></svg>`;

const escapeHtml = (str) =>
  String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

const buildEmailHtml = ({ nombre, email, password, rolLabel }) => `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  <title>Credenciales de acceso — Terrasacha</title>
</head>
<body style="margin:0;padding:0;background-color:#f5f5f0;font-family:Arial,Helvetica,sans-serif;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0"
         style="background-color:#f5f5f0;">
    <tr>
      <td align="center" style="padding:40px 16px;">
        <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0"
               style="max-width:560px;background-color:#ffffff;border-radius:12px;
                      box-shadow:0 2px 12px rgba(0,0,0,0.08);overflow:hidden;">

          <!-- Encabezado con logo -->
          <tr>
            <td style="background-color:#70752B;padding:32px 40px 24px;text-align:center;">
              ${LOGO_SVG}
              <p style="margin:14px 0 0;color:#e8d79a;font-size:12px;letter-spacing:3px;
                         text-transform:uppercase;font-family:Arial,Helvetica,sans-serif;">
                Pioneros del Mañana
              </p>
            </td>
          </tr>

          <!-- Franja de acento -->
          <tr>
            <td style="background-color:#44482c;height:4px;font-size:0;line-height:0;">&nbsp;</td>
          </tr>

          <!-- Cuerpo -->
          <tr>
            <td style="padding:36px 40px 28px;">
              <p style="margin:0 0 8px;color:#44482c;font-size:22px;font-weight:bold;">
                ¡Bienvenido/a, ${escapeHtml(nombre)}!
              </p>
              <p style="margin:0 0 24px;color:#666;font-size:14px;line-height:1.6;">
                Tu cuenta en la plataforma <strong>Terrasacha</strong> ha sido creada.
                A continuación encontrarás tus credenciales de acceso.
              </p>

              <!-- Bloque de credenciales -->
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0"
                     style="background-color:#f5f5f0;border-radius:8px;border-left:4px solid #70752B;">
                <tr>
                  <td style="padding:20px 24px;">
                    <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0">
                      <tr>
                        <td style="padding:6px 0;">
                          <span style="color:#888;font-size:11px;text-transform:uppercase;
                                       letter-spacing:1px;">Rol asignado</span><br/>
                          <strong style="color:#44482c;font-size:15px;">${escapeHtml(rolLabel)}</strong>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding:6px 0;border-top:1px solid #e0e0d8;">
                          <span style="color:#888;font-size:11px;text-transform:uppercase;
                                       letter-spacing:1px;">Usuario (correo)</span><br/>
                          <strong style="color:#44482c;font-size:15px;">${escapeHtml(email)}</strong>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding:6px 0;border-top:1px solid #e0e0d8;">
                          <span style="color:#888;font-size:11px;text-transform:uppercase;
                                       letter-spacing:1px;">Contraseña temporal</span><br/>
                          <strong style="color:#70752B;font-size:18px;letter-spacing:2px;
                                         font-family:'Courier New',Courier,monospace;">
                            ${escapeHtml(password)}
                          </strong>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>

              <!-- Aviso -->
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0"
                     style="margin-top:20px;background-color:#fff8e1;border-radius:8px;
                            border-left:4px solid #e8d79a;">
                <tr>
                  <td style="padding:14px 18px;">
                    <p style="margin:0;color:#5a4a00;font-size:13px;line-height:1.5;">
                      &#9888;&#65039; <strong>Debes cambiar tu contraseña</strong> en el primer
                      inicio de sesión. Esta contraseña temporal es de un solo uso.
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Separador -->
          <tr>
            <td style="padding:0 40px;">
              <hr style="border:none;border-top:1px solid #e8e8e0;margin:0;"/>
            </td>
          </tr>

          <!-- Pie -->
          <tr>
            <td style="padding:20px 40px 32px;text-align:center;">
              <p style="margin:0 0 4px;color:#999;font-size:12px;">
                Este correo fue generado automáticamente por
                <strong style="color:#70752B;">Terrasacha</strong>.
              </p>
              <p style="margin:0;color:#bbb;font-size:11px;">
                Si no esperabas este mensaje, ignóralo o contacta a tu líder de proyecto.
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;

const sendCredentialsEmail = async ({ email, nombre, password, rol }) => {
  const fromEmail = process.env.SES_EMAIL;
  const sesRegion = process.env.SES_REGION || 'us-east-1';

  console.log('[SES] Iniciando envío de correo');
  console.log('[SES] SES_EMAIL:', fromEmail || '(no configurado)');
  console.log('[SES] SES_REGION:', sesRegion);
  console.log('[SES] Destinatario:', email);
  console.log('[SES] Nombre:', nombre);
  console.log('[SES] Rol:', rol);

  if (!fromEmail) {
    console.error('[SES] ERROR: SES_EMAIL no está configurado en las variables de entorno');
    return { sent: false, reason: 'SES_EMAIL no configurado' };
  }

  const rolLabel =
    rol === 'lider_cuadrilla' ? 'Líder de cuadrilla' : 'Operador';

  const bodyText = [
    `Hola ${nombre},`,
    '',
    'Tu cuenta en Terrasacha fue creada por tu líder de proyecto.',
    '',
    `Rol asignado: ${rolLabel}`,
    `Usuario (correo): ${email}`,
    `Contraseña temporal: ${password}`,
    '',
    'Debes cambiar tu contraseña en el primer inicio de sesión.',
    '',
    'Saludos,',
    'Equipo Terrasacha — Pioneros del Mañana',
  ].join('\n');

  const emailParams = {
    Source: `Terrasacha <${fromEmail}>`,
    Destination: { ToAddresses: [email] },
    Message: {
      Subject: {
        Data: 'Tus credenciales de acceso — Terrasacha',
        Charset: 'UTF-8',
      },
      Body: {
        Html: {
          Data: buildEmailHtml({ nombre, email, password, rolLabel }),
          Charset: 'UTF-8',
        },
        Text: {
          Data: bodyText,
          Charset: 'UTF-8',
        },
      },
    },
  };

  console.log('[SES] Parámetros del comando:', JSON.stringify({
    Source: emailParams.Source,
    Destination: emailParams.Destination,
    Subject: emailParams.Message.Subject.Data,
  }));

  try {
    const result = await ses.send(new SendEmailCommand(emailParams));
    console.log('[SES] Correo enviado exitosamente. MessageId:', result.MessageId);
    return { sent: true, messageId: result.MessageId };
  } catch (error) {
    console.error('[SES] ERROR al enviar correo:');
    console.error('[SES]   Nombre del error:', error.name);
    console.error('[SES]   Mensaje:', error.message);
    console.error('[SES]   Código HTTP:', error.$metadata?.httpStatusCode);
    console.error('[SES]   requestId:', error.$metadata?.requestId);
    console.error('[SES]   Stack:', error.stack);
    return { sent: false, reason: error.message };
  }
};

const assertLiderProyecto = async (event) => {
  const token = getBearerToken(event.headers);
  if (!token) {
    return { ok: false, statusCode: 401, error: 'Token de autorización requerido' };
  }

  let payload;
  try {
    payload = await getJwtVerifier().verify(token);
  } catch (error) {
    console.error('JWT inválido:', error);
    return { ok: false, statusCode: 401, error: 'Token inválido o expirado' };
  }

  // El claim custom:role puede no estar en el JWT si el App Client de Cognito
  // no tiene ese atributo en sus ReadAttributes. Por eso consultamos AdminGetUser
  // directamente, lo cual es siempre autoritativo.
  try {
    const userInfo = await cognito.send(
      new AdminGetUserCommand({
        UserPoolId: process.env.USER_POOL_ID,
        Username: payload['cognito:username'] || payload.username || payload.sub,
      }),
    );

    const roleAttr = (userInfo.UserAttributes || []).find(
      (a) => a.Name === 'custom:role',
    );
    const rol = roleAttr?.Value;

    if (rol !== ROL_LIDER_PROYECTO) {
      return {
        ok: false,
        statusCode: 403,
        error: 'Solo el líder de proyecto puede gestionar usuarios',
      };
    }

    return { ok: true, callerSub: payload.sub };
  } catch (error) {
    console.error('Error verificando rol en Cognito:', error);
    return { ok: false, statusCode: 403, error: 'No se pudo verificar el rol del usuario' };
  }
};

const handleCreate = async (body) => {
  const email = (body.email || '').trim().toLowerCase();
  const nombre = (body.nombre || '').trim();
  const rol = (body.rol || '').trim();
  const mediciones = Array.isArray(body.mediciones) ? body.mediciones : [];
  const departamento = (body.departamento || '').trim() || null;
  const municipioUbicacion = (body.municipio || '').trim() || null;

  if (!email || !nombre) {
    return jsonResponse(400, { exito: false, error: 'Nombre y correo son obligatorios' });
  }

  if (!ROLES_PERMITIDOS_CREAR.has(rol)) {
    return jsonResponse(400, {
      exito: false,
      error: 'Rol inválido. Use lider_cuadrilla u operador',
    });
  }

  const tempPassword = generateTemporaryPassword();
  const userPoolId = process.env.USER_POOL_ID;
  let cognitoUsername = email;

  try {
    await cognito.send(
      new AdminCreateUserCommand({
        UserPoolId: userPoolId,
        Username: email,
        TemporaryPassword: tempPassword,
        MessageAction: 'SUPPRESS',
        UserAttributes: [
          { Name: 'email', Value: email },
          { Name: 'email_verified', Value: 'true' },
          { Name: 'custom:role', Value: rol },
          { Name: 'name', Value: nombre },
        ],
      }),
    );
  } catch (error) {
    console.error('AdminCreateUser error:', error);
    return jsonResponse(400, {
      exito: false,
      error: error.message || 'No se pudo crear el usuario en Cognito',
    });
  }

  let sub;
  try {
    const userInfo = await cognito.send(
      new AdminGetUserCommand({
        UserPoolId: userPoolId,
        Username: email,
      }),
    );
    sub =
      userInfo.UserAttributes?.find((attr) => attr.Name === 'sub')?.Value ||
      userInfo.Username;
    cognitoUsername = userInfo.Username;
  } catch (error) {
    console.error('AdminGetUser error:', error);
    await cognito
      .send(
        new AdminDeleteUserCommand({
          UserPoolId: userPoolId,
          Username: email,
        }),
      )
      .catch(() => {});
    return jsonResponse(500, {
      exito: false,
      error: 'Usuario creado en Cognito pero no se pudo obtener el sub',
    });
  }

  const metadata = buildUserMetadata({
    email,
    rol,
    mediciones,
    activo: true,
    departamentoUbicacion: departamento,
    municipioUbicacion,
  });

  let userRecord;
  try {
    userRecord = await createUserRecord({
      id: sub,
      nombre,
      metadata,
    });
  } catch (error) {
    console.error('createUser GraphQL error:', error);
    await cognito
      .send(
        new AdminDeleteUserCommand({
          UserPoolId: userPoolId,
          Username: cognitoUsername,
        }),
      )
      .catch(() => {});
    return jsonResponse(500, {
      exito: false,
      error: `No se pudo guardar en la base de datos: ${error.message}`,
    });
  }

  const emailResult = await sendCredentialsEmail({
    email,
    nombre,
    password: tempPassword,
    rol,
  });

  return jsonResponse(200, {
    exito: true,
    mensaje: emailResult.sent
      ? 'Usuario creado. Se enviaron las credenciales por correo.'
      : `Usuario creado. No se pudo enviar el correo: ${emailResult.reason || 'error desconocido'}`,
    user: {
      id: userRecord.id,
      nombre: userRecord.departamento,
      email,
      rol,
      mediciones,
      activo: true,
      emailEnviado: emailResult.sent,
    },
  });
};

const handleList = async () => {
  const records = await listUserRecords();

  const usuarios = records
    .map((record) => {
      const meta = parseUserMetadata(record.municipio);
      if (!meta.rol || !ROLES_PERMITIDOS_CREAR.has(meta.rol)) {
        return null;
      }
      return {
        id: record.id,
        nombre: record.departamento || meta.email || 'Sin nombre',
        email: meta.email,
        rol: meta.rol,
        mediciones: meta.mediciones,
        activo: meta.activo,
      };
    })
    .filter(Boolean);

  return jsonResponse(200, { exito: true, usuarios });
};

const handleUpdateRole = async (body) => {
  const userId = (body.userId || body.id || '').trim();
  const rol = (body.rol || '').trim();

  if (!userId) {
    return jsonResponse(400, { exito: false, error: 'userId es obligatorio' });
  }

  if (!ROLES_PERMITIDOS_CREAR.has(rol)) {
    return jsonResponse(400, {
      exito: false,
      error: 'Rol inválido. Use lider_cuadrilla u operador',
    });
  }

  let userRecord;
  try {
    userRecord = await getUserRecord(userId);
  } catch (error) {
    console.error('getUser error:', error);
    return jsonResponse(500, {
      exito: false,
      error: `No se pudo leer el usuario: ${error.message}`,
    });
  }

  if (!userRecord) {
    return jsonResponse(404, { exito: false, error: 'Usuario no encontrado' });
  }

  const meta = parseUserMetadata(userRecord.municipio);
  if (meta.rol === rol) {
    return jsonResponse(200, {
      exito: true,
      mensaje: 'El usuario ya tiene ese rol',
      user: {
        id: userRecord.id,
        nombre: userRecord.departamento || meta.email || 'Sin nombre',
        email: meta.email,
        rol,
        mediciones: meta.mediciones,
        activo: meta.activo,
      },
    });
  }

  const username = await resolveCognitoUsername({
    email: meta.email,
    userId,
  });

  if (!username) {
    return jsonResponse(404, {
      exito: false,
      error: 'No se encontró el usuario en Cognito',
    });
  }

  try {
    await cognito.send(
      new AdminUpdateUserAttributesCommand({
        UserPoolId: process.env.USER_POOL_ID,
        Username: username,
        UserAttributes: [{ Name: 'custom:role', Value: rol }],
      }),
    );
  } catch (error) {
    console.error('AdminUpdateUserAttributes error:', error);
    return jsonResponse(400, {
      exito: false,
      error: error.message || 'No se pudo actualizar el rol en Cognito',
    });
  }

  const metadata = buildUserMetadata({
    email: meta.email,
    rol,
    mediciones: meta.mediciones,
    activo: meta.activo,
    departamentoUbicacion: meta.departamentoUbicacion,
    municipioUbicacion: meta.municipioUbicacion,
  });

  // parseUserMetadata no expone ubicación; preservar el JSON original si aplica
  let metadataFinal = metadata;
  try {
    const original = userRecord.municipio ? JSON.parse(userRecord.municipio) : {};
    metadataFinal = JSON.stringify({
      ...original,
      email: meta.email,
      rol,
      mediciones: meta.mediciones || [],
      activo: meta.activo !== false,
    });
  } catch {
    metadataFinal = metadata;
  }

  try {
    userRecord = await updateUserRecord({
      id: userId,
      nombre: userRecord.departamento || meta.email || 'Sin nombre',
      metadata: metadataFinal,
    });
  } catch (error) {
    console.error('updateUser GraphQL error:', error);
    return jsonResponse(500, {
      exito: false,
      error:
        `Rol actualizado en Cognito, pero no en la base de datos: ${error.message}`,
    });
  }

  const metaActualizado = parseUserMetadata(userRecord.municipio);
  return jsonResponse(200, {
    exito: true,
    mensaje: 'Rol actualizado en Cognito',
    user: {
      id: userRecord.id,
      nombre: userRecord.departamento || metaActualizado.email || 'Sin nombre',
      email: metaActualizado.email,
      rol: metaActualizado.rol || rol,
      mediciones: metaActualizado.mediciones,
      activo: metaActualizado.activo,
    },
  });
};

exports.handler = async (event) => {
  const httpMethod =
    event.requestContext?.http?.method || event.httpMethod || 'POST';

  if (httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers: corsHeaders, body: '' };
  }

  if (httpMethod !== 'POST') {
    return jsonResponse(405, { exito: false, error: 'Método no permitido' });
  }

  let body = {};
  try {
    body =
      typeof event.body === 'string'
        ? JSON.parse(event.body || '{}')
        : event.body || {};
  } catch {
    return jsonResponse(400, { exito: false, error: 'JSON inválido' });
  }

  const auth = await assertLiderProyecto(event);
  if (!auth.ok) {
    return jsonResponse(auth.statusCode, { exito: false, error: auth.error });
  }

  const action = body.action || 'create';

  try {
    if (action === 'list') {
      return await handleList();
    }
    if (action === 'create') {
      return await handleCreate(body);
    }
    if (action === 'updateRole') {
      return await handleUpdateRole(body);
    }
    return jsonResponse(400, {
      exito: false,
      error: 'Acción no soportada. Use create, list o updateRole',
    });
  } catch (error) {
    console.error('Error inesperado:', error);
    return jsonResponse(500, {
      exito: false,
      error: error.message || 'Error interno',
    });
  }
};
