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


/** This is an auto generated class representing the UnitOfMeasure type in your schema. */
class UnitOfMeasure extends amplify_core.Model {
  static const classType = const _UnitOfMeasureModelType();
  final String id;
  final String? _name;
  final String? _abbreviation;
  final List<Feature>? _features;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UnitOfMeasureModelIdentifier get modelIdentifier {
      return UnitOfMeasureModelIdentifier(
        id: id
      );
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
  
  String? get abbreviation {
    return _abbreviation;
  }
  
  List<Feature>? get features {
    return _features;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UnitOfMeasure._internal({required this.id, required name, abbreviation, features, createdAt, updatedAt}): _name = name, _abbreviation = abbreviation, _features = features, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UnitOfMeasure({String? id, required String name, String? abbreviation, List<Feature>? features}) {
    return UnitOfMeasure._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      abbreviation: abbreviation,
      features: features != null ? List<Feature>.unmodifiable(features) : features);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnitOfMeasure &&
      id == other.id &&
      _name == other._name &&
      _abbreviation == other._abbreviation &&
      DeepCollectionEquality().equals(_features, other._features);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UnitOfMeasure {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("abbreviation=" + "$_abbreviation" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UnitOfMeasure copyWith({String? name, String? abbreviation, List<Feature>? features}) {
    return UnitOfMeasure._internal(
      id: id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      features: features ?? this.features);
  }
  
  UnitOfMeasure copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? abbreviation,
    ModelFieldValue<List<Feature>?>? features
  }) {
    return UnitOfMeasure._internal(
      id: id,
      name: name == null ? this.name : name.value,
      abbreviation: abbreviation == null ? this.abbreviation : abbreviation.value,
      features: features == null ? this.features : features.value
    );
  }
  
  UnitOfMeasure.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _abbreviation = json['abbreviation'],
      _features = json['features']  is Map
        ? (json['features']['items'] is List
          ? (json['features']['items'] as List)
              .where((e) => e != null)
              .map((e) => Feature.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['features'] is List
          ? (json['features'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Feature.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'abbreviation': _abbreviation, 'features': _features?.map((Feature? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'abbreviation': _abbreviation,
    'features': _features,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UnitOfMeasureModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UnitOfMeasureModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final ABBREVIATION = amplify_core.QueryField(fieldName: "abbreviation");
  static final FEATURES = amplify_core.QueryField(
    fieldName: "features",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Feature'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UnitOfMeasure";
    modelSchemaDefinition.pluralName = "UnitOfMeasures";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UnitOfMeasure.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UnitOfMeasure.ABBREVIATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: UnitOfMeasure.FEATURES,
      isRequired: false,
      ofModelName: 'Feature',
      associatedKey: Feature.UNITOFMEASURE
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

class _UnitOfMeasureModelType extends amplify_core.ModelType<UnitOfMeasure> {
  const _UnitOfMeasureModelType();
  
  @override
  UnitOfMeasure fromJson(Map<String, dynamic> jsonData) {
    return UnitOfMeasure.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UnitOfMeasure';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UnitOfMeasure] in your schema.
 */
class UnitOfMeasureModelIdentifier implements amplify_core.ModelIdentifier<UnitOfMeasure> {
  final String id;

  /** Create an instance of UnitOfMeasureModelIdentifier using [id] the primary key. */
  const UnitOfMeasureModelIdentifier({
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
  String toString() => 'UnitOfMeasureModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UnitOfMeasureModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}