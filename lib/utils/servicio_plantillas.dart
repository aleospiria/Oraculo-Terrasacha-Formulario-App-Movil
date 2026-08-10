import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class FeaturePlantillaResumen {
  final String id;
  final String nombre;
  final String? featureType;
  final String? featureGroup;
  final String? description;
  final String? templateFeatureId;
  /// Si es true, en campo se pide un valor numérico exacto (independiente
  /// de Variable / Constante / KPI).
  final bool isFloat;
  final String? unitOfMeasure;

  const FeaturePlantillaResumen({
    required this.id,
    required this.nombre,
    this.featureType,
    this.featureGroup,
    this.description,
    this.templateFeatureId,
    this.isFloat = false,
    this.unitOfMeasure,
  });

  /// Unidad real para mostrar; ignora placeholders como `No-Unit`.
  String? get unidadVisible {
    final u = unitOfMeasure?.trim();
    if (u == null || u.isEmpty) return null;
    final normalizado = u.toLowerCase().replaceAll(RegExp(r'[\s_\-]+'), '');
    const invalidas = {
      'nounit',
      'nound',
      'none',
      'null',
      'na',
      'n/a',
      'sinunidad',
      'sinunidades',
    };
    if (invalidas.contains(normalizado)) return null;
    return u;
  }

  bool get requiereValorNumerico => isFloat;
}

class PlantillaConFeatures {
  final String id;
  final String nombre;
  final String? descripcion;
  final int type;
  final List<FeaturePlantillaResumen> features;

  const PlantillaConFeatures({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.type = 1,
    this.features = const [],
  });
}

class ServicioPlantillas {
  /// Tipo Form según schema GraphQL (`type: Int! # 1. Form`).
  static const int tipoFormulario = 1;
  static const Duration _timeoutApi = Duration(seconds: 12);
  static const Duration _timeoutDataStore = Duration(seconds: 6);
  static const Duration _ttlCache = Duration(minutes: 3);

  static List<PlantillaConFeatures>? _cacheMemoria;
  static DateTime? _cacheMemoriaEn;

  static void invalidarCache() {
    _cacheMemoria = null;
    _cacheMemoriaEn = null;
  }

  static void _guardarCache(List<PlantillaConFeatures> plantillas) {
    if (plantillas.isEmpty) return;
    _cacheMemoria = List<PlantillaConFeatures>.from(plantillas);
    _cacheMemoriaEn = DateTime.now();
  }

  static const _listTemplatesQuery = r'''
    query ListTemplatesLatest {
      listTemplates(filter: { is_latest: { eq: true } }, limit: 100) {
        items {
          id
          name
          description
          type
          templateFeatures {
            items {
              id
              feature {
                id
                name
                description
                feature_type
                feature_group
                is_float
                unitOfMeasure {
                  id
                  name
                  abbreviation
                }
              }
            }
          }
        }
      }
    }
  ''';

  static const _getTemplateQuery = r'''
    query GetTemplateConFeatures($id: ID!) {
      getTemplate(id: $id) {
        id
        name
        description
        type
        templateFeatures {
          items {
            id
            feature {
              id
              name
              description
              feature_type
              feature_group
              is_float
              unitOfMeasure {
                id
                name
                abbreviation
              }
            }
          }
        }
      }
    }
  ''';

  static Future<List<PlantillaConFeatures>> cargarPlantillasConFeatures({
    bool forzarRefresh = false,
  }) async {
    if (!forzarRefresh &&
        _cacheMemoria != null &&
        _cacheMemoria!.isNotEmpty &&
        _cacheMemoriaEn != null &&
        DateTime.now().difference(_cacheMemoriaEn!) < _ttlCache) {
      return List<PlantillaConFeatures>.from(_cacheMemoria!);
    }

    // Preferir DataStore: abre el sheet en ms sin esperar la API.
    try {
      final local = await _cargarDesdeDataStore().timeout(
        _timeoutDataStore,
        onTimeout: () => <PlantillaConFeatures>[],
      );
      if (local.isNotEmpty) {
        _guardarCache(local);
        // Actualiza en segundo plano sin bloquear la UI.
        // ignore: unawaited_futures
        _refrescarCacheDesdeApi();
        return local;
      }
    } catch (e) {
      safePrint('ServicioPlantillas DataStore: $e');
    }

    try {
      final desdeApi = await _cargarDesdeApi().timeout(
        _timeoutApi,
        onTimeout: () => <PlantillaConFeatures>[],
      );
      if (desdeApi.isNotEmpty) {
        _guardarCache(desdeApi);
        return desdeApi;
      }
    } catch (e) {
      safePrint('ServicioPlantillas API: $e');
    }

    return List<PlantillaConFeatures>.from(_cacheMemoria ?? const []);
  }

  static Future<void> _refrescarCacheDesdeApi() async {
    try {
      final desdeApi = await _cargarDesdeApi().timeout(
        _timeoutApi,
        onTimeout: () => <PlantillaConFeatures>[],
      );
      if (desdeApi.isNotEmpty) _guardarCache(desdeApi);
    } catch (e) {
      safePrint('ServicioPlantillas refresh API: $e');
    }
  }

  static Future<PlantillaConFeatures?> obtenerPlantilla(String plantillaId) async {
    // Preferir DataStore (plantillas recién creadas offline / locales).
    try {
      final templates = await Amplify.DataStore.query(
        Template.classType,
        where: Template.ID.eq(plantillaId),
      ).timeout(_timeoutDataStore, onTimeout: () => <Template>[]);

      if (templates.isNotEmpty) {
        final t = templates.first;
        final features = await _featuresDePlantillaDataStore(t.id);
        return PlantillaConFeatures(
          id: t.id,
          nombre: t.name,
          descripcion: t.description,
          type: t.type,
          features: features,
        );
      }
    } catch (e) {
      safePrint('ServicioPlantillas obtenerPlantilla DataStore: $e');
    }

    try {
      final desdeApi = await _obtenerDesdeApi(plantillaId).timeout(
        _timeoutApi,
        onTimeout: () => null,
      );
      if (desdeApi != null) return desdeApi;
    } catch (e) {
      safePrint('ServicioPlantillas obtenerPlantilla API: $e');
    }

    try {
      final todas = await cargarPlantillasConFeatures();
      for (final p in todas) {
        if (p.id == plantillaId) return p;
      }
    } catch (_) {}
    return null;
  }

  static Future<PlantillaConFeatures?> _obtenerDesdeApi(String plantillaId) async {
    final request = GraphQLRequest<String>(
      document: _getTemplateQuery,
      variables: {'id': plantillaId},
    );
    final response = await Amplify.API.query(request: request).response;
    if (response.errors.isNotEmpty || response.data == null) return null;

    final jsonData = jsonDecode(response.data!) as Map<String, dynamic>;
    final item = jsonData['getTemplate'] as Map<String, dynamic>?;
    if (item == null) return null;
    return _parsePlantillaApi(item);
  }

  static Future<PlantillaConFeatures> crearPlantilla({
    required String nombre,
    String? descripcion,
  }) async {
    final limpio = nombre.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El nombre de la plantilla es obligatorio');
    }

    final template = Template(
      name: limpio,
      description: descripcion?.trim().isEmpty == true
          ? null
          : descripcion?.trim(),
      type: tipoFormulario,
      version: '1',
      is_latest: true,
    );

    await Amplify.DataStore.save(template);
    invalidarCache();

    return PlantillaConFeatures(
      id: template.id,
      nombre: template.name,
      descripcion: template.description,
      type: template.type,
      features: const [],
    );
  }

  static Future<PlantillaConFeatures> actualizarPlantilla({
    required String plantillaId,
    required String nombre,
    String? descripcion,
  }) async {
    final limpio = nombre.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El nombre de la plantilla es obligatorio');
    }

    final existentes = await Amplify.DataStore.query(
      Template.classType,
      where: Template.ID.eq(plantillaId),
    );
    if (existentes.isEmpty) {
      throw StateError('Plantilla no encontrada');
    }

    final actual = existentes.first.copyWith(
      name: limpio,
      description:
          descripcion?.trim().isEmpty == true ? null : descripcion?.trim(),
    );
    await Amplify.DataStore.save(actual);

    final features = await _featuresDePlantillaDataStore(plantillaId);
    invalidarCache();
    return PlantillaConFeatures(
      id: actual.id,
      nombre: actual.name,
      descripcion: actual.description,
      type: actual.type,
      features: features,
    );
  }

  /// Elimina la plantilla, sus vínculos TemplateFeature y los Features
  /// asociados que no estén ligados a otras plantillas.
  static Future<void> eliminarPlantilla(String plantillaId) async {
    final vinculos = await Amplify.DataStore.query(
      TemplateFeature.classType,
      where: TemplateFeature.TEMPLATE.eq(plantillaId),
    );

    for (final tf in vinculos) {
      final featureId = tf.feature?.id;
      await Amplify.DataStore.delete(tf);
      if (featureId != null) {
        await _eliminarFeatureSiHuerfano(featureId);
      }
    }

    final templates = await Amplify.DataStore.query(
      Template.classType,
      where: Template.ID.eq(plantillaId),
    );
    for (final t in templates) {
      await Amplify.DataStore.delete(t);
    }
    invalidarCache();
  }

  static Future<FeaturePlantillaResumen> crearFeatureEnPlantilla({
    required String plantillaId,
    required String nombre,
    String? descripcion,
    String? featureType,
    String? featureGroup,
    bool requiereValorNumerico = true,
  }) async {
    final limpio = nombre.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El nombre del feature es obligatorio');
    }

    final templates = await Amplify.DataStore.query(
      Template.classType,
      where: Template.ID.eq(plantillaId),
    );
    if (templates.isEmpty) {
      throw StateError('Plantilla no encontrada');
    }
    final template = templates.first;

    final feature = Feature(
      name: limpio,
      description:
          descripcion?.trim().isEmpty == true ? null : descripcion?.trim(),
      feature_type: (featureType?.trim().isEmpty ?? true)
          ? 'variable'
          : featureType!.trim(),
      feature_group: featureGroup?.trim().isEmpty == true
          ? null
          : featureGroup?.trim(),
      is_float: requiereValorNumerico,
    );
    await Amplify.DataStore.save(feature);

    final vinculo = TemplateFeature(template: template, feature: feature);
    await Amplify.DataStore.save(vinculo);
    invalidarCache();

    return FeaturePlantillaResumen(
      id: feature.id,
      nombre: feature.name,
      description: feature.description,
      featureType: feature.feature_type,
      featureGroup: feature.feature_group,
      templateFeatureId: vinculo.id,
      isFloat: feature.is_float ?? requiereValorNumerico,
      unitOfMeasure: feature.unitOfMeasure?.abbreviation ??
          feature.unitOfMeasure?.name,
    );
  }

  static Future<FeaturePlantillaResumen> actualizarFeature({
    required String featureId,
    required String nombre,
    String? descripcion,
    String? featureType,
    String? featureGroup,
    bool? requiereValorNumerico,
  }) async {
    final limpio = nombre.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El nombre del feature es obligatorio');
    }

    final features = await Amplify.DataStore.query(
      Feature.classType,
      where: Feature.ID.eq(featureId),
    );
    if (features.isEmpty) {
      throw StateError('Feature no encontrado');
    }

    final actual = features.first.copyWith(
      name: limpio,
      description:
          descripcion?.trim().isEmpty == true ? null : descripcion?.trim(),
      feature_type: (featureType?.trim().isEmpty ?? true)
          ? features.first.feature_type
          : featureType!.trim(),
      feature_group: featureGroup?.trim().isEmpty == true
          ? null
          : featureGroup?.trim(),
      is_float: requiereValorNumerico ?? features.first.is_float,
    );
    await Amplify.DataStore.save(actual);
    invalidarCache();

    return FeaturePlantillaResumen(
      id: actual.id,
      nombre: actual.name,
      description: actual.description,
      featureType: actual.feature_type,
      featureGroup: actual.feature_group,
      isFloat: actual.is_float ?? false,
      unitOfMeasure: actual.unitOfMeasure?.abbreviation ??
          actual.unitOfMeasure?.name,
    );
  }

  /// Quita el feature de la plantilla y lo borra si no queda en otras.
  static Future<void> eliminarFeatureDePlantilla({
    required String plantillaId,
    required String featureId,
    String? templateFeatureId,
  }) async {
    List<TemplateFeature> vinculos;
    if (templateFeatureId != null && templateFeatureId.isNotEmpty) {
      vinculos = await Amplify.DataStore.query(
        TemplateFeature.classType,
        where: TemplateFeature.ID.eq(templateFeatureId),
      );
    } else {
      vinculos = await Amplify.DataStore.query(
        TemplateFeature.classType,
        where: TemplateFeature.TEMPLATE
            .eq(plantillaId)
            .and(TemplateFeature.FEATURE.eq(featureId)),
      );
    }

    for (final tf in vinculos) {
      await Amplify.DataStore.delete(tf);
    }

    await _eliminarFeatureSiHuerfano(featureId);
    invalidarCache();
  }

  static Future<void> _eliminarFeatureSiHuerfano(String featureId) async {
    final otros = await Amplify.DataStore.query(
      TemplateFeature.classType,
      where: TemplateFeature.FEATURE.eq(featureId),
    );
    if (otros.isNotEmpty) return;

    final features = await Amplify.DataStore.query(
      Feature.classType,
      where: Feature.ID.eq(featureId),
    );
    for (final f in features) {
      await Amplify.DataStore.delete(f);
    }
  }

  static Future<List<PlantillaConFeatures>> _cargarDesdeApi() async {
    final request = GraphQLRequest<String>(document: _listTemplatesQuery);
    final response = await Amplify.API.query(request: request).response;

    if (response.errors.isNotEmpty || response.data == null) {
      return [];
    }

    final jsonData = jsonDecode(response.data!) as Map<String, dynamic>;
    final items =
        jsonData['listTemplates']?['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => _parsePlantillaApi(item as Map<String, dynamic>))
        .where((p) => p.nombre.isNotEmpty)
        .toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
  }

  static PlantillaConFeatures _parsePlantillaApi(Map<String, dynamic> item) {
    final tfItems =
        item['templateFeatures']?['items'] as List<dynamic>? ?? [];
    final features = <FeaturePlantillaResumen>[];

    for (final tf in tfItems) {
      if (tf == null) continue;
      final map = Map<String, dynamic>.from(tf as Map);
      final featureRaw = map['feature'];
      if (featureRaw is! Map) continue;
      final feature = Map<String, dynamic>.from(featureRaw);
      final id = feature['id'] as String?;
      final name = feature['name'] as String?;
      if (id == null || name == null) continue;
      features.add(
        FeaturePlantillaResumen(
          id: id,
          nombre: name,
          description: feature['description'] as String?,
          featureType: feature['feature_type'] as String?,
          featureGroup: feature['feature_group'] as String?,
          templateFeatureId: map['id'] as String?,
          isFloat: feature['is_float'] as bool? ?? false,
          unitOfMeasure: _unidadDesdeApi(feature['unitOfMeasure']),
        ),
      );
    }

    return PlantillaConFeatures(
      id: item['id'] as String,
      nombre: item['name'] as String? ?? '',
      descripcion: item['description'] as String?,
      type: item['type'] as int? ?? tipoFormulario,
      features: features,
    );
  }

  static Future<List<PlantillaConFeatures>> _cargarDesdeDataStore() async {
    final templates = await Amplify.DataStore.query(
      Template.classType,
      where: Template.IS_LATEST.eq(true),
    ).timeout(_timeoutDataStore, onTimeout: () => <Template>[]);

    // Cargar catálogos una sola vez para evitar N+1 colgado.
    final vinculos = await Amplify.DataStore.query(TemplateFeature.classType)
        .timeout(_timeoutDataStore, onTimeout: () => <TemplateFeature>[]);
    final allFeatures = await Amplify.DataStore.query(Feature.classType)
        .timeout(_timeoutDataStore, onTimeout: () => <Feature>[]);
    final featuresById = <String, Feature>{
      for (final f in allFeatures) f.id: f,
    };

    final resultado = <PlantillaConFeatures>[];

    for (final template in templates) {
      final features = <FeaturePlantillaResumen>[];
      for (final tf in vinculos) {
        final templateId = tf.template?.id;
        if (templateId != template.id) continue;

        final featureId = tf.feature?.id;
        if (featureId == null) continue;

        Feature? feature = featuresById[featureId];
        feature ??= _featureSeguro(tf.feature);
        if (feature == null) continue;

        features.add(
          FeaturePlantillaResumen(
            id: feature.id,
            nombre: _nombreFeatureSeguro(feature),
            description: feature.description,
            featureType: feature.feature_type,
            featureGroup: feature.feature_group,
            templateFeatureId: tf.id,
            isFloat: feature.is_float ?? false,
            unitOfMeasure: feature.unitOfMeasure?.abbreviation ??
                feature.unitOfMeasure?.name,
          ),
        );
      }
      features.sort((a, b) => a.nombre.compareTo(b.nombre));

      resultado.add(
        PlantillaConFeatures(
          id: template.id,
          nombre: template.name,
          descripcion: template.description,
          type: template.type,
          features: features,
        ),
      );
    }

    resultado.sort((a, b) => a.nombre.compareTo(b.nombre));
    return resultado;
  }

  static Future<List<FeaturePlantillaResumen>> _featuresDePlantillaDataStore(
    String plantillaId,
  ) async {
    final templateFeatures = await Amplify.DataStore.query(
      TemplateFeature.classType,
      where: TemplateFeature.TEMPLATE.eq(plantillaId),
    ).timeout(_timeoutDataStore, onTimeout: () => <TemplateFeature>[]);

    final featureIds = <String>{};
    for (final tf in templateFeatures) {
      final id = tf.feature?.id;
      if (id != null) featureIds.add(id);
    }

    final featuresById = <String, Feature>{};
    if (featureIds.isNotEmpty) {
      final allFeatures = await Amplify.DataStore.query(Feature.classType)
          .timeout(_timeoutDataStore, onTimeout: () => <Feature>[]);
      for (final f in allFeatures) {
        if (featureIds.contains(f.id)) featuresById[f.id] = f;
      }
    }

    final features = <FeaturePlantillaResumen>[];
    for (final tf in templateFeatures) {
      final featureId = tf.feature?.id;
      if (featureId == null) continue;

      final feature =
          featuresById[featureId] ?? _featureSeguro(tf.feature);
      if (feature == null) continue;

      features.add(
        FeaturePlantillaResumen(
          id: feature.id,
          nombre: _nombreFeatureSeguro(feature),
          description: feature.description,
          featureType: feature.feature_type,
          featureGroup: feature.feature_group,
          templateFeatureId: tf.id,
          isFloat: feature.is_float ?? false,
          unitOfMeasure: feature.unitOfMeasure?.abbreviation ??
              feature.unitOfMeasure?.name,
        ),
      );
    }
    features.sort((a, b) => a.nombre.compareTo(b.nombre));
    return features;
  }

  static String? _unidadDesdeApi(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final abrev = map['abbreviation'] as String?;
    if (abrev != null && abrev.trim().isNotEmpty) return abrev.trim();
    final name = map['name'] as String?;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    return null;
  }

  /// Carga metadatos de un feature (p. ej. si requiere valor numérico).
  static Future<FeaturePlantillaResumen?> obtenerFeaturePorId(
    String featureId,
  ) async {
    try {
      final features = await Amplify.DataStore.query(
        Feature.classType,
        where: Feature.ID.eq(featureId),
      ).timeout(_timeoutDataStore, onTimeout: () => <Feature>[]);
      if (features.isNotEmpty) {
        final f = features.first;
        return FeaturePlantillaResumen(
          id: f.id,
          nombre: _nombreFeatureSeguro(f),
          description: f.description,
          featureType: f.feature_type,
          featureGroup: f.feature_group,
          isFloat: f.is_float ?? false,
          unitOfMeasure: f.unitOfMeasure?.abbreviation ?? f.unitOfMeasure?.name,
        );
      }
    } catch (e) {
      safePrint('obtenerFeaturePorId DataStore: $e');
    }

    try {
      const query = r'''
        query GetFeature($id: ID!) {
          getFeature(id: $id) {
            id
            name
            description
            feature_type
            feature_group
            is_float
            unitOfMeasure {
              id
              name
              abbreviation
            }
          }
        }
      ''';
      final response = await Amplify.API
          .query(
            request: GraphQLRequest<String>(
              document: query,
              variables: {'id': featureId},
            ),
          )
          .response
          .timeout(_timeoutApi);
      if (response.data == null) return null;
      final jsonData = jsonDecode(response.data!) as Map<String, dynamic>;
      final feature = jsonData['getFeature'] as Map<String, dynamic>?;
      if (feature == null) return null;
      final id = feature['id'] as String?;
      final name = feature['name'] as String?;
      if (id == null || name == null) return null;
      return FeaturePlantillaResumen(
        id: id,
        nombre: name,
        description: feature['description'] as String?,
        featureType: feature['feature_type'] as String?,
        featureGroup: feature['feature_group'] as String?,
        isFloat: feature['is_float'] as bool? ?? false,
        unitOfMeasure: _unidadDesdeApi(feature['unitOfMeasure']),
      );
    } catch (e) {
      safePrint('obtenerFeaturePorId API: $e');
      return null;
    }
  }

  static Feature? _featureSeguro(Feature? feature) {
    if (feature == null) return null;
    try {
      // Fuerza lectura de name; si el stub está incompleto, falla.
      final _ = feature.name;
      return feature;
    } catch (_) {
      return null;
    }
  }

  static String _nombreFeatureSeguro(Feature feature) {
    try {
      return feature.name;
    } catch (_) {
      return feature.id;
    }
  }
}
