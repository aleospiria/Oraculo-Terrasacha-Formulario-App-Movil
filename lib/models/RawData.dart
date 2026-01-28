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


/** This is an auto generated class representing the RawData type in your schema. */
class RawData extends amplify_core.Model {
  static const classType = const _RawDataModelType();
  final String id;
  final String? _name;
  final double? _valueFloat;
  final String? _valueString;
  final amplify_core.TemporalDateTime? _timestamp;
  final Feature? _feature;
  final Tree? _tree;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RawDataModelIdentifier get modelIdentifier {
      return RawDataModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  double? get valueFloat {
    return _valueFloat;
  }
  
  String? get valueString {
    return _valueString;
  }
  
  amplify_core.TemporalDateTime? get timestamp {
    return _timestamp;
  }
  
  Feature? get feature {
    return _feature;
  }
  
  Tree? get tree {
    return _tree;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const RawData._internal({required this.id, name, valueFloat, valueString, timestamp, feature, tree, createdAt, updatedAt}): _name = name, _valueFloat = valueFloat, _valueString = valueString, _timestamp = timestamp, _feature = feature, _tree = tree, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory RawData({String? id, String? name, double? valueFloat, String? valueString, amplify_core.TemporalDateTime? timestamp, Feature? feature, Tree? tree}) {
    return RawData._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      valueFloat: valueFloat,
      valueString: valueString,
      timestamp: timestamp,
      feature: feature,
      tree: tree);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RawData &&
      id == other.id &&
      _name == other._name &&
      _valueFloat == other._valueFloat &&
      _valueString == other._valueString &&
      _timestamp == other._timestamp &&
      _feature == other._feature &&
      _tree == other._tree;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RawData {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("valueFloat=" + (_valueFloat != null ? _valueFloat!.toString() : "null") + ", ");
    buffer.write("valueString=" + "$_valueString" + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.format() : "null") + ", ");
    buffer.write("feature=" + (_feature != null ? _feature!.toString() : "null") + ", ");
    buffer.write("tree=" + (_tree != null ? _tree!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RawData copyWith({String? name, double? valueFloat, String? valueString, amplify_core.TemporalDateTime? timestamp, Feature? feature, Tree? tree}) {
    return RawData._internal(
      id: id,
      name: name ?? this.name,
      valueFloat: valueFloat ?? this.valueFloat,
      valueString: valueString ?? this.valueString,
      timestamp: timestamp ?? this.timestamp,
      feature: feature ?? this.feature,
      tree: tree ?? this.tree);
  }
  
  RawData copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<double?>? valueFloat,
    ModelFieldValue<String?>? valueString,
    ModelFieldValue<amplify_core.TemporalDateTime?>? timestamp,
    ModelFieldValue<Feature?>? feature,
    ModelFieldValue<Tree?>? tree
  }) {
    return RawData._internal(
      id: id,
      name: name == null ? this.name : name.value,
      valueFloat: valueFloat == null ? this.valueFloat : valueFloat.value,
      valueString: valueString == null ? this.valueString : valueString.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      feature: feature == null ? this.feature : feature.value,
      tree: tree == null ? this.tree : tree.value
    );
  }
  
  RawData.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _valueFloat = (json['valueFloat'] as num?)?.toDouble(),
      _valueString = json['valueString'],
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null,
      _feature = json['feature'] != null
        ? json['feature']['serializedData'] != null
          ? Feature.fromJson(new Map<String, dynamic>.from(json['feature']['serializedData']))
          : Feature.fromJson(new Map<String, dynamic>.from(json['feature']))
        : null,
      _tree = json['tree'] != null
        ? json['tree']['serializedData'] != null
          ? Tree.fromJson(new Map<String, dynamic>.from(json['tree']['serializedData']))
          : Tree.fromJson(new Map<String, dynamic>.from(json['tree']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'valueFloat': _valueFloat, 'valueString': _valueString, 'timestamp': _timestamp?.format(), 'feature': _feature?.toJson(), 'tree': _tree?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'valueFloat': _valueFloat,
    'valueString': _valueString,
    'timestamp': _timestamp,
    'feature': _feature,
    'tree': _tree,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RawDataModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RawDataModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final VALUEFLOAT = amplify_core.QueryField(fieldName: "valueFloat");
  static final VALUESTRING = amplify_core.QueryField(fieldName: "valueString");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final FEATURE = amplify_core.QueryField(
    fieldName: "feature",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Feature'));
  static final TREE = amplify_core.QueryField(
    fieldName: "tree",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Tree'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RawData";
    modelSchemaDefinition.pluralName = "RawData";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RawData.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RawData.VALUEFLOAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RawData.VALUESTRING,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RawData.TIMESTAMP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RawData.FEATURE,
      isRequired: false,
      targetNames: ['featureRawDatasId'],
      ofModelName: 'Feature'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RawData.TREE,
      isRequired: false,
      targetNames: ['treeRawDataId'],
      ofModelName: 'Tree'
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

class _RawDataModelType extends amplify_core.ModelType<RawData> {
  const _RawDataModelType();
  
  @override
  RawData fromJson(Map<String, dynamic> jsonData) {
    return RawData.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'RawData';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RawData] in your schema.
 */
class RawDataModelIdentifier implements amplify_core.ModelIdentifier<RawData> {
  final String id;

  /** Create an instance of RawDataModelIdentifier using [id] the primary key. */
  const RawDataModelIdentifier({
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
  String toString() => 'RawDataModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RawDataModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}