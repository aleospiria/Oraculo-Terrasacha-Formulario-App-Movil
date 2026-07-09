import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';

class FeaturePlantillaResumen {
  final String id;
  final String nombre;
  final String? featureType;
  final String? featureGroup;

  const FeaturePlantillaResumen({
    required this.id,
    required this.nombre,
    this.featureType,
    this.featureGroup,
  });
}

class PlantillaConFeatures {
  final String id;
  final String nombre;
  final String? descripcion;
  final List<FeaturePlantillaResumen> features;

  const PlantillaConFeatures({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.features = const [],
  });
}

class ServicioPlantillas {
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
                feature_type
                feature_group
              }
            }
          }
        }
      }
    }
  ''';

  static Future<List<PlantillaConFeatures>> cargarPlantillasConFeatures() async {
    try {
      final desdeApi = await _cargarDesdeApi();
      if (desdeApi.isNotEmpty) return desdeApi;
    } catch (e) {
      safePrint('ServicioPlantillas API: $e');
    }
    return _cargarDesdeDataStore();
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
        .where((p) => p.features.isNotEmpty || p.nombre.isNotEmpty)
        .toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
  }

  static PlantillaConFeatures _parsePlantillaApi(Map<String, dynamic> item) {
    final tfItems =
        item['templateFeatures']?['items'] as List<dynamic>? ?? [];
    final features = <FeaturePlantillaResumen>[];

    for (final tf in tfItems) {
      final feature = tf['feature'] as Map<String, dynamic>?;
      if (feature == null) continue;
      final id = feature['id'] as String?;
      final name = feature['name'] as String?;
      if (id == null || name == null) continue;
      features.add(
        FeaturePlantillaResumen(
          id: id,
          nombre: name,
          featureType: feature['feature_type'] as String?,
          featureGroup: feature['feature_group'] as String?,
        ),
      );
    }

    return PlantillaConFeatures(
      id: item['id'] as String,
      nombre: item['name'] as String? ?? '',
      descripcion: item['description'] as String?,
      features: features,
    );
  }

  static Future<List<PlantillaConFeatures>> _cargarDesdeDataStore() async {
    final templates = await Amplify.DataStore.query(
      Template.classType,
      where: Template.IS_LATEST.eq(true),
    );

    final resultado = <PlantillaConFeatures>[];

    for (final template in templates) {
      final templateFeatures = await Amplify.DataStore.query(
        TemplateFeature.classType,
        where: TemplateFeature.TEMPLATE.eq(template.id),
      );

      final features = <FeaturePlantillaResumen>[];
      for (final tf in templateFeatures) {
        Feature? feature = tf.feature;
        if (feature == null) continue;
        features.add(
          FeaturePlantillaResumen(
            id: feature.id,
            nombre: feature.name,
            featureType: feature.feature_type,
            featureGroup: feature.feature_group,
          ),
        );
      }

      resultado.add(
        PlantillaConFeatures(
          id: template.id,
          nombre: template.name,
          descripcion: template.description,
          features: features,
        ),
      );
    }

    resultado.sort((a, b) => a.nombre.compareTo(b.nombre));
    return resultado;
  }
}
