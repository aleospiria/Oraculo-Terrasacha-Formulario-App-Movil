/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the SatelliteTopologyModelAI type in your schema. */
class SatelliteTopologyModelAI extends amplify_core.Model {
  static const classType = const _SatelliteTopologyModelAIModelType();
  final String id;
  final SatelliteTopology? _satelliteTopology;
  final ModelAI? _modelAI;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SatelliteTopologyModelAIModelIdentifier get modelIdentifier {
      return SatelliteTopologyModelAIModelIdentifier(
        id: id
      );
  }
  
  SatelliteTopology? get satelliteTopology {
    return _satelliteTopology;
  }
  
  ModelAI? get modelAI {
    return _modelAI;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SatelliteTopologyModelAI._internal({required this.id, satelliteTopology, modelAI, createdAt, updatedAt}): _satelliteTopology = satelliteTopology, _modelAI = modelAI, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SatelliteTopologyModelAI({String? id, SatelliteTopology? satelliteTopology, ModelAI? modelAI}) {
    return SatelliteTopologyModelAI._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      satelliteTopology: satelliteTopology,
      modelAI: modelAI);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SatelliteTopologyModelAI &&
      id == other.id &&
      _satelliteTopology == other._satelliteTopology &&
      _modelAI == other._modelAI;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SatelliteTopologyModelAI {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("satelliteTopology=" + (_satelliteTopology != null ? _satelliteTopology!.toString() : "null") + ", ");
    buffer.write("modelAI=" + (_modelAI != null ? _modelAI!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SatelliteTopologyModelAI copyWith({SatelliteTopology? satelliteTopology, ModelAI? modelAI}) {
    return SatelliteTopologyModelAI._internal(
      id: id,
      satelliteTopology: satelliteTopology ?? this.satelliteTopology,
      modelAI: modelAI ?? this.modelAI);
  }
  
  SatelliteTopologyModelAI copyWithModelFieldValues({
    ModelFieldValue<SatelliteTopology?>? satelliteTopology,
    ModelFieldValue<ModelAI?>? modelAI
  }) {
    return SatelliteTopologyModelAI._internal(
      id: id,
      satelliteTopology: satelliteTopology == null ? this.satelliteTopology : satelliteTopology.value,
      modelAI: modelAI == null ? this.modelAI : modelAI.value
    );
  }
  
  SatelliteTopologyModelAI.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _satelliteTopology = json['satelliteTopology'] != null
        ? json['satelliteTopology']['serializedData'] != null
          ? SatelliteTopology.fromJson(new Map<String, dynamic>.from(json['satelliteTopology']['serializedData']))
          : SatelliteTopology.fromJson(new Map<String, dynamic>.from(json['satelliteTopology']))
        : null,
      _modelAI = json['modelAI'] != null
        ? json['modelAI']['serializedData'] != null
          ? ModelAI.fromJson(new Map<String, dynamic>.from(json['modelAI']['serializedData']))
          : ModelAI.fromJson(new Map<String, dynamic>.from(json['modelAI']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'satelliteTopology': _satelliteTopology?.toJson(), 'modelAI': _modelAI?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'satelliteTopology': _satelliteTopology,
    'modelAI': _modelAI,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SatelliteTopologyModelAIModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SatelliteTopologyModelAIModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SATELLITETOPOLOGY = amplify_core.QueryField(
    fieldName: "satelliteTopology",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SatelliteTopology'));
  static final MODELAI = amplify_core.QueryField(
    fieldName: "modelAI",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ModelAI'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SatelliteTopologyModelAI";
    modelSchemaDefinition.pluralName = "SatelliteTopologyModelAIS";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: SatelliteTopologyModelAI.SATELLITETOPOLOGY,
      isRequired: false,
      targetNames: ['satelliteTopologySatelliteTopologyModelAIsId'],
      ofModelName: 'SatelliteTopology'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: SatelliteTopologyModelAI.MODELAI,
      isRequired: false,
      targetNames: ['modelAISatelliteTopologyModelAIsId'],
      ofModelName: 'ModelAI'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _SatelliteTopologyModelAIModelType extends amplify_core.ModelType<SatelliteTopologyModelAI> {
  const _SatelliteTopologyModelAIModelType();
  
  @override
  SatelliteTopologyModelAI fromJson(Map<String, dynamic> jsonData) {
    return SatelliteTopologyModelAI.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SatelliteTopologyModelAI';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SatelliteTopologyModelAI] in your schema.
 */
class SatelliteTopologyModelAIModelIdentifier implements amplify_core.ModelIdentifier<SatelliteTopologyModelAI> {
  final String id;

  /** Create an instance of SatelliteTopologyModelAIModelIdentifier using [id] the primary key. */
  const SatelliteTopologyModelAIModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'SatelliteTopologyModelAIModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SatelliteTopologyModelAIModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}