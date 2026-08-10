import  'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/reporte_accidente.dart';

class ExportadorPdf {
  static Future<void> exportar(ReporteAccidente r) async {
    final pdf = await _generar([r]);
    final fileName = 'accidente_${_sufijo()}.pdf';
    await _compartir(pdf, fileName, 'Reporte de accidente - ${r.trabajadorNombre}');
  }

  static Future<void> exportarMultiples(List<ReporteAccidente> reportes) async {
    final pdf = await _generar(reportes);
    final fileName = 'reportes_accidentes_${_sufijo()}.pdf';
    await _compartir(pdf, fileName, '${reportes.length} reportes de accidentes');
  }

  static Future<List<int>> _generar(List<ReporteAccidente> reportes) async {
    final doc = pw.Document();

    for (final r in reportes) {
      final fotos = await _leerFotos(r.id, r.fotosEvidencia);
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (ctx) => _buildPagina(r, fotosBytes: fotos),
        ),
      );
    }

    return await doc.save();
  }

  static Future<Map<String, List<int>>> _leerFotos(
      String id, List<String> nombres) async {
    if (nombres.isEmpty) return {};
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/reportes_accidentes/${id}_fotos');
    if (!await dir.exists()) return {};

    final map = <String, List<int>>{};
    for (final nombre in nombres) {
      final file = File('${dir.path}/$nombre');
      if (await file.exists()) {
        map[nombre] = await file.readAsBytes();
      }
    }
    return map;
  }

  static List<pw.Widget> _buildPagina(ReporteAccidente r,
      {Map<String, List<int>>? fotosBytes}) {
    return [
      _titulo(),
      pw.SizedBox(height: 16),
      _seccion('1. Información del empleador', [
          _campo('Razón social', r.razonSocial),
          _campo('NIT', r.nit),
          _campo('Dirección principal', r.direccion),
          _campo('Teléfono', r.telefono),
          _campo('ARL', r.arl),
          _campo('Actividad económica', r.actividadEconomica),
        ]),
        _seccion('2. Información del trabajador / contratista', [
          _campo('Nombre completo', r.trabajadorNombre),
          _campo('Tipo de identificación', r.trabajadorTipoId),
          _campo('Número de identificación', r.trabajadorNumeroId),
          _campo('Cargo o rol en la visita', r.trabajadorCargo),
          _campo('Tipo de contrato', r.trabajadorTipoContrato),
          _campo('Antigüedad en el cargo', r.trabajadorAntiguedad),
          _campo('Teléfono de contacto', r.trabajadorTelefono),
        ]),
        _seccion('3. Información de la visita de campo', [
          _campo('Nombre del predio', r.predioNombre),
          _campo('Municipio', r.predioMunicipio),
          _campo('Departamento', r.predioDepartamento),
          _campo('Tipo de actividad', r.visitaTipoActividad),
        ]),
        _seccion('4. Información del accidente', [
          _campo('Fecha',
              '${r.accidenteFecha.day}/${r.accidenteFecha.month}/${r.accidenteFecha.year}'),
          _campo('Hora', r.accidenteHora),
          _campo('Lugar (coordenadas)', r.accidenteLugarCoordenadas),
          _campo('Tipo de accidente', r.accidenteTipo),
          if (r.accidenteTipoOtro != null && r.accidenteTipoOtro!.isNotEmpty)
            _campo('Especificación otro tipo', r.accidenteTipoOtro!),
          _campo('Descripción', r.accidenteDescripcion),
          _campo('Parte del cuerpo afectada', r.accidenteParteCuerpo),
          _campo('Tipo de lesión', r.accidenteTipoLesion),
          _campo('Atención médica inmediata', r.accidenteAtencionMedica ? 'Sí' : 'No'),
          if (r.accidenteAtencionMedica)
            _campo('Centro asistencial', r.accidenteCentroAsistencial),
          _campo('Accidente con incapacidad', r.accidenteIncapacidad ? 'Sí' : 'No'),
          if (r.accidenteIncapacidad)
            _campo('Días de incapacidad', r.accidenteDiasIncapacidad?.toString() ?? ''),
          _campo('Chequeo preoperacional', r.accidenteChequeoPreop ? 'Sí' : 'No'),
          if (r.accidenteChequeoPreop && r.accidenteResultadoChequeo != null)
            _campo('Resultado chequeo', r.accidenteResultadoChequeo!),
          _campo('Causa principal', r.accidenteCausaPrincipal),
          if (fotosBytes != null && fotosBytes.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text('Fotos de evidencia:',
                style: pw.TextStyle(
                    fontSize: 9, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            ...fotosBytes.entries.map((e) => pw.SizedBox(
                  width: 400,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Image(pw.MemoryImage(Uint8List.fromList(e.value)),
                        fit: pw.BoxFit.contain),
                  ),
                )),
          ],
        ]),
        _seccion('5. Condiciones del entorno', [
          _campo('Condiciones climáticas', r.entornoClima),
          _campo('Estado del terreno', r.entornoTerreno),
          _campo('Uso de EPP', r.entornoUsoEPP ? 'Sí' : 'No'),
          _campo('Tipo de riesgo', r.entornoTipoRiesgo),
        ]),
        if (r.testigoNombre != null || r.testigoContacto != null)
          _seccion('6. Testigos', [
            if (r.testigoNombre != null && r.testigoNombre!.isNotEmpty)
              _campo('Nombre', r.testigoNombre!),
            if (r.testigoContacto != null && r.testigoContacto!.isNotEmpty)
              _campo('Contacto', r.testigoContacto!),
          ]),
        _seccion('7. Datos del reporte', [
          _campo('Nombre de quien reporta', r.reporteNombre),
          _campo('Cargo', r.reporteCargo),
          _campo('Fecha de diligenciamiento',
              '${r.reporteFecha.day}/${r.reporteFecha.month}/${r.reporteFecha.year}'),
          if (r.audiosEvidencia.isNotEmpty) ...[
            _campo('Notas de voz', '${r.audiosEvidencia.length} grabación(es)'),
            ...List.generate(r.audiosEvidencia.length, (i) {
              final d = r.audiosDuracion.length > i ? r.audiosDuracion[i] : 0;
              final mm = (d ~/ 60).toString().padLeft(2, '0');
              final ss = (d % 60).toString().padLeft(2, '0');
              return _campo('  Nota ${i + 1}', '$mm:$ss min');
            }),
          ],
          if (r.esFirmaImagen && r.firmaBytes != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 120,
                    child: pw.Text('Firma:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    constraints: const pw.BoxConstraints(maxHeight: 50, maxWidth: 150),
                    child: pw.Image(pw.MemoryImage(r.firmaBytes!)),
                  ),
                ],
              ),
            )
          else
            _campo('Firma', r.reporteFirma ?? ''),
        ]),
        if (r.hashActual != null) ...[
          pw.SizedBox(height: 8),
          pw.Divider(height: 1),
          pw.SizedBox(height: 4),
          _campo('Hash de integridad (SHA-256)', r.hashActual!),
          if (r.hashAnterior != null)
            _campo('Hash anterior', r.hashAnterior!),
        ],
      ];
  }

  static pw.Widget _titulo() {
    return pw.Column(
      children: [
        pw.Text(
          'TERRASACHA',
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(0xFF6E6C35),
          ),
        ),
        pw.Text(
          'Reporte de Accidente de Trabajo',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  static pw.Widget _seccion(String titulo, List<pw.Widget> campos) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 14),
        pw.Container(
          color: PdfColor.fromInt(0xFF6E6C35),
          padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: pw.Text(
            titulo,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.SizedBox(height: 6),
        ...campos,
      ],
    );
  }

  static pw.Widget _campo(String label, String valor) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              valor.isNotEmpty ? valor : '(sin registrar)',
              style: pw.TextStyle(fontSize: 9, color: valor.isNotEmpty ? PdfColors.black : PdfColors.grey),
            ),
          ),
        ],
      ),
    );
  }

  static String _sufijo() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  static Future<void> _compartir(List<int> bytes, String fileName, String subject) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path)],
      subject: subject,
    ));
  }
}
