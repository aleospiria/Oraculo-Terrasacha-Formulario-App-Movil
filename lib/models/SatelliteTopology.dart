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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the SatelliteTopology type in your schema. */
class SatelliteTopology extends amplify_core.Model {
  static const classType = const _SatelliteTopologyModelType();
  final String id;
  final String? _type;
  final String? _name;
  final String? _description;
  final SatelliteTopology? _satelliteTopologyParent;
  final List<SatelliteTopology>? _satelliteTopologies;
  final List<SatelliteTopologyModelAI>? _satelliteTopologyModelAIs;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SatelliteTopologyModelIdentifier get modelIdentifier {
      return SatelliteTopologyModelIdentifier(
        id: id
      );
  }
  
  String get type {
    try {
      return _type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  SatelliteTopology? get satelliteTopologyParent {
    return _satelliteTopologyParent;
  }
  
  List<SatelliteTopology>? get satelliteTopologies {
    return _satelliteTopologies;
  }
  
  List<SatelliteTopologyModelAI>? get satelliteTopologyModelAIs {
    return _satelliteTopologyModelAIs;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SatelliteTopology._internal({required this.id, required type, required name, required description, satelliteTopologyParent, satelliteTopologies, satelliteTopologyModelAIs, createdAt, updatedAt}): _type = type, _name = name, _description = description, _satelliteTopologyParent = satelliteTopologyParent, _satelliteTopologies = satelliteTopologies, _satelliteTopologyModelAIs = satelliteTopologyModelAIs, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SatelliteTopology({String? id, required String type, required String name, required String description, SatelliteTopology? satelliteTopologyParent, List<SatelliteTopology>? satelliteTopologies, List<SatelliteTopologyModelAI>? satelliteTopologyModelAIs}) {
    return SatelliteTopology._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      name: name,
      description: description,
      satelliteTopologyParent: satelliteTopologyParent,
      satelliteTopologies: satelliteTopologies != null ? List<SatelliteTopology>.unmodifiable(satelliteTopologies) : satelliteTopologies,
      satelliteTopologyModelAIs: satelliteTopologyModelAIs != null ? List<SatelliteTopologyModelAI>.unmodifiable(satelliteTopologyModelAIs) : satelliteTopologyModelAIs);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SatelliteTopology &&
      id == other.id &&
      _type == other._type &&
      _name == other._name &&
      _description == other._description &&
      _satelliteTopologyParent == other._satelliteTopologyParent &&
      DeepCollectionEquality().equals(_satelliteTopologies, other._satelliteTopologies) &&
      DeepCollectionEquality().equals(_satelliteTopologyModelAIs, other._satelliteTopologyModelAIs);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SatelliteTopology {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("satelliteTopologyParent=" + (_satelliteTopologyParent != null ? _satelliteTopologyParent!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SatelliteTopology copyWith({String? type, String? name, String? description, SatelliteTopology? satelliteTopologyParent, List<SatelliteTopology>? satelliteTopologies, List<SatelliteTopologyModelAI>? satelliteTopologyModelAIs}) {
    return SatelliteTopology._internal(
      id: id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      satelliteTopologyParent: satelliteTopologyParent ?? this.satelliteTopologyParent,
      satelliteTopologies: satelliteTopologies ?? this.satelliteTopologies,
      satelliteTopologyModelAIs: satelliteTopologyModelAIs ?? this.satelliteTopologyModelAIs);
  }
  
  SatelliteTopology copyWithModelFieldValues({
    ModelFieldValue<String>? type,
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? description,
    ModelFieldValue<SatelliteTopology?>? satelliteTopologyParent,
    ModelFieldValue<List<SatelliteTopology>?>? satelliteTopologies,
    ModelFieldValue<List<SatelliteTopologyModelAI>?>? satelliteTopologyModelAIs
  }) {
    return SatelliteTopology._internal(
      id: id,
      type: type == null ? this.type : type.value,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      satelliteTopologyParent: satelliteTopologyParent == null ? this.satelliteTopologyParent : satelliteTopologyParent.value,
      satelliteTopologies: satelliteTopologies == null ? this.satelliteTopologies : satelliteTopologies.value,
      satelliteTopologyModelAIs: satelliteTopologyModelAIs == null ? this.satelliteTopologyModelAIs : satelliteTopologyModelAIs.value
    );
  }
  
  SatelliteTopology.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = json['type'],
      _name = json['name'],
      _description = json['description'],
      _satelliteTopologyParent = json['satelliteTopologyParent'] != null
        ? json['satelliteTopologyParent']['serializedData'] != null
          ? SatelliteTopology.fromJson(new Map<String, dynamic>.from(json['satelliteTopologyParent']['serializedData']))
          : SatelliteTopology.fromJson(new Map<String, dynamic>.from(json['satelliteTopologyParent']))
        : null,
      _satelliteTopologies = json['satelliteTopologies']  is Map
        ? (json['satelliteTopologies']['items'] is List
          ? (json['satelliteTopologies']['items'] as List)
              .where((e) => e != null)
              .map((e) => SatelliteTopology.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['satelliteTopologies'] is List
          ? (json['satelliteTopologies'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => SatelliteTopology.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _satelliteTopologyModelAIs = json['satelliteTopologyModelAIs']  is Map
        ? (json['satelliteTopologyModelAIs']['items'] is List
          ? (json['satelliteTopologyModelAIs']['items'] as List)
              .where((e) => e != null)
              .map((e) => SatelliteTopologyModelAI.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['satelliteTopologyModelAIs'] is List
          ? (json['satelliteTopologyModelAIs'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => SatelliteTopologyModelAI.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': _type, 'name': _name, 'description': _description, 'satelliteTopologyParent': _satelliteTopologyParent?.toJson(), 'satelliteTopologies': _satelliteTopologies?.map((SatelliteTopology? e) => e?.toJson()).toList(), 'satelliteTopologyModelAIs': _satelliteTopologyModelAIs?.map((SatelliteTopologyModelAI? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'name': _name,
    'description': _description,
    'satelliteTopologyParent': _satelliteTopologyParent,
    'satelliteTopologies': _satelliteTopologies,
    'satelliteTopologyModelAIs': _satelliteTopologyModelAIs,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SatelliteTopologyModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SatelliteTopologyModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final SATELLITETOPOLOGYPARENT = amplify_core.QueryField(
    fieldName: "satelliteTopologyParent",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SatelliteTopology'));
  static final SATELLITETOPOLOGIES = amplify_core.QueryField(
    fieldName: "satelliteTopologies",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SatelliteTopology'));
  static final SATELLITETOPOLOGYMODELAIS = amplify_core.QueryField(
    fieldName: "satelliteTopologyModelAIs",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SatelliteTopologyModelAI'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SatelliteTopology";
    modelSchemaDefinition.pluralName = "SatelliteTopologies";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SatelliteTopology.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SatelliteTopology.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SatelliteTopology.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: SatelliteTopology.SATELLITETOPOLOGYPARENT,
      isRequired: false,
      targetNames: ['satelliteTopologySatelliteTopologiesId'],
      ofModelName: 'SatelliteTopology'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: SatelliteTopology.SATELLITETOPOLOGIES,
      isRequired: false,
      ofModelName: 'SatelliteTopology',
      associatedKey: SatelliteTopology.SATELLITETOPOLOGYPARENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: SatelliteTopology.SATELLITETOPOLOGYMODELAIS,
      isRequired: false,
      ofModelName: 'SatelliteTopologyModelAI',
      associatedKey: SatelliteTopologyModelAI.SATELLITETOPOLOGY
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

class _SatelliteTopologyModelType extends amplify_core.ModelType<SatelliteTopology> {
  const _SatelliteTopologyModelType();
  
  @override
  SatelliteTopology fromJson(Map<String, dynamic> jsonData) {
    return SatelliteTopology.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SatelliteTopology';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SatelliteTopology] in your schema.
 */
class SatelliteTopologyModelIdentifier implements amplify_core.ModelIdentifier<SatelliteTopology> {
  final String id;

  /** Create an instance of SatelliteTopologyModelIdentifier using [id] the primary key. */
  const SatelliteTopologyModelIdentifier({
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
  String toString() => 'SatelliteTopologyModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SatelliteTopologyModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}