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


/** This is an auto generated class representing the Feature type in your schema. */
class Feature extends amplify_core.Model {
  static const classType = const _FeatureModelType();
  final String id;
  final String? _feature_type;
  final String? _name;
  final String? _description;
  final String? _feature_group;
  final double? _default_value;
  final bool? _is_float;
  final UnitOfMeasure? _unitOfMeasure;
  final List<TemplateFeature>? _templateFeatures;
  final List<RawData>? _rawDatas;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  FeatureModelIdentifier get modelIdentifier {
      return FeatureModelIdentifier(
        id: id
      );
  }
  
  String? get feature_type {
    return _feature_type;
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
  
  String? get description {
    return _description;
  }
  
  String? get feature_group {
    return _feature_group;
  }
  
  double? get default_value {
    return _default_value;
  }
  
  bool? get is_float {
    return _is_float;
  }
  
  UnitOfMeasure? get unitOfMeasure {
    return _unitOfMeasure;
  }
  
  List<TemplateFeature>? get templateFeatures {
    return _templateFeatures;
  }
  
  List<RawData>? get rawDatas {
    return _rawDatas;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Feature._internal({required this.id, feature_type, required name, description, feature_group, default_value, is_float, unitOfMeasure, templateFeatures, rawDatas, createdAt, updatedAt}): _feature_type = feature_type, _name = name, _description = description, _feature_group = feature_group, _default_value = default_value, _is_float = is_float, _unitOfMeasure = unitOfMeasure, _templateFeatures = templateFeatures, _rawDatas = rawDatas, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Feature({String? id, String? feature_type, required String name, String? description, String? feature_group, double? default_value, bool? is_float, UnitOfMeasure? unitOfMeasure, List<TemplateFeature>? templateFeatures, List<RawData>? rawDatas}) {
    return Feature._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      feature_type: feature_type,
      name: name,
      description: description,
      feature_group: feature_group,
      default_value: default_value,
      is_float: is_float,
      unitOfMeasure: unitOfMeasure,
      templateFeatures: templateFeatures != null ? List<TemplateFeature>.unmodifiable(templateFeatures) : templateFeatures,
      rawDatas: rawDatas != null ? List<RawData>.unmodifiable(rawDatas) : rawDatas);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Feature &&
      id == other.id &&
      _feature_type == other._feature_type &&
      _name == other._name &&
      _description == other._description &&
      _feature_group == other._feature_group &&
      _default_value == other._default_value &&
      _is_float == other._is_float &&
      _unitOfMeasure == other._unitOfMeasure &&
      DeepCollectionEquality().equals(_templateFeatures, other._templateFeatures) &&
      DeepCollectionEquality().equals(_rawDatas, other._rawDatas);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Feature {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("feature_type=" + "$_feature_type" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("feature_group=" + "$_feature_group" + ", ");
    buffer.write("default_value=" + (_default_value != null ? _default_value!.toString() : "null") + ", ");
    buffer.write("is_float=" + (_is_float != null ? _is_float!.toString() : "null") + ", ");
    buffer.write("unitOfMeasure=" + (_unitOfMeasure != null ? _unitOfMeasure!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Feature copyWith({String? feature_type, String? name, String? description, String? feature_group, double? default_value, bool? is_float, UnitOfMeasure? unitOfMeasure, List<TemplateFeature>? templateFeatures, List<RawData>? rawDatas}) {
    return Feature._internal(
      id: id,
      feature_type: feature_type ?? this.feature_type,
      name: name ?? this.name,
      description: description ?? this.description,
      feature_group: feature_group ?? this.feature_group,
      default_value: default_value ?? this.default_value,
      is_float: is_float ?? this.is_float,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      templateFeatures: templateFeatures ?? this.templateFeatures,
      rawDatas: rawDatas ?? this.rawDatas);
  }
  
  Feature copyWithModelFieldValues({
    ModelFieldValue<String?>? feature_type,
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? feature_group,
    ModelFieldValue<double?>? default_value,
    ModelFieldValue<bool?>? is_float,
    ModelFieldValue<UnitOfMeasure?>? unitOfMeasure,
    ModelFieldValue<List<TemplateFeature>?>? templateFeatures,
    ModelFieldValue<List<RawData>?>? rawDatas
  }) {
    return Feature._internal(
      id: id,
      feature_type: feature_type == null ? this.feature_type : feature_type.value,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      feature_group: feature_group == null ? this.feature_group : feature_group.value,
      default_value: default_value == null ? this.default_value : default_value.value,
      is_float: is_float == null ? this.is_float : is_float.value,
      unitOfMeasure: unitOfMeasure == null ? this.unitOfMeasure : unitOfMeasure.value,
      templateFeatures: templateFeatures == null ? this.templateFeatures : templateFeatures.value,
      rawDatas: rawDatas == null ? this.rawDatas : rawDatas.value
    );
  }
  
  Feature.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _feature_type = json['feature_type'],
      _name = json['name'],
      _description = json['description'],
      _feature_group = json['feature_group'],
      _default_value = (json['default_value'] as num?)?.toDouble(),
      _is_float = json['is_float'],
      _unitOfMeasure = json['unitOfMeasure'] != null
        ? json['unitOfMeasure']['serializedData'] != null
          ? UnitOfMeasure.fromJson(new Map<String, dynamic>.from(json['unitOfMeasure']['serializedData']))
          : UnitOfMeasure.fromJson(new Map<String, dynamic>.from(json['unitOfMeasure']))
        : null,
      _templateFeatures = json['templateFeatures']  is Map
        ? (json['templateFeatures']['items'] is List
          ? (json['templateFeatures']['items'] as List)
              .where((e) => e != null)
              .map((e) => TemplateFeature.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['templateFeatures'] is List
          ? (json['templateFeatures'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => TemplateFeature.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _rawDatas = json['rawDatas']  is Map
        ? (json['rawDatas']['items'] is List
          ? (json['rawDatas']['items'] as List)
              .where((e) => e != null)
              .map((e) => RawData.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['rawDatas'] is List
          ? (json['rawDatas'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => RawData.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'feature_type': _feature_type, 'name': _name, 'description': _description, 'feature_group': _feature_group, 'default_value': _default_value, 'is_float': _is_float, 'unitOfMeasure': _unitOfMeasure?.toJson(), 'templateFeatures': _templateFeatures?.map((TemplateFeature? e) => e?.toJson()).toList(), 'rawDatas': _rawDatas?.map((RawData? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'feature_type': _feature_type,
    'name': _name,
    'description': _description,
    'feature_group': _feature_group,
    'default_value': _default_value,
    'is_float': _is_float,
    'unitOfMeasure': _unitOfMeasure,
    'templateFeatures': _templateFeatures,
    'rawDatas': _rawDatas,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<FeatureModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<FeatureModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FEATURE_TYPE = amplify_core.QueryField(fieldName: "feature_type");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final FEATURE_GROUP = amplify_core.QueryField(fieldName: "feature_group");
  static final DEFAULT_VALUE = amplify_core.QueryField(fieldName: "default_value");
  static final IS_FLOAT = amplify_core.QueryField(fieldName: "is_float");
  static final UNITOFMEASURE = amplify_core.QueryField(
    fieldName: "unitOfMeasure",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UnitOfMeasure'));
  static final TEMPLATEFEATURES = amplify_core.QueryField(
    fieldName: "templateFeatures",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'TemplateFeature'));
  static final RAWDATAS = amplify_core.QueryField(
    fieldName: "rawDatas",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RawData'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Feature";
    modelSchemaDefinition.pluralName = "Features";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feature.FEATURE_TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feature.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feature.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feature.FEATURE_GROUP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feature.DEFAULT_VALUE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feature.IS_FLOAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Feature.UNITOFMEASURE,
      isRequired: false,
      targetNames: ['unitOfMeasureFeaturesId'],
      ofModelName: 'UnitOfMeasure'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Feature.TEMPLATEFEATURES,
      isRequired: false,
      ofModelName: 'TemplateFeature',
      associatedKey: TemplateFeature.FEATURE
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Feature.RAWDATAS,
      isRequired: false,
      ofModelName: 'RawData',
      associatedKey: RawData.FEATURE
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

class _FeatureModelType extends amplify_core.ModelType<Feature> {
  const _FeatureModelType();
  
  @override
  Feature fromJson(Map<String, dynamic> jsonData) {
    return Feature.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Feature';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Feature] in your schema.
 */
class FeatureModelIdentifier implements amplify_core.ModelIdentifier<Feature> {
  final String id;

  /** Create an instance of FeatureModelIdentifier using [id] the primary key. */
  const FeatureModelIdentifier({
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
  String toString() => 'FeatureModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is FeatureModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}