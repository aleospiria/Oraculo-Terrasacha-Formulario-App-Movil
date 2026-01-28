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


/** This is an auto generated class representing the Tree type in your schema. */
class Tree extends amplify_core.Model {
  static const classType = const _TreeModelType();
  final String id;
  final String? _name;
  final String? _status;
  final Project? _project;
  final Template? _template;
  final List<RawData>? _rawData;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TreeModelIdentifier get modelIdentifier {
      return TreeModelIdentifier(
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
  
  String? get status {
    return _status;
  }
  
  Project? get project {
    return _project;
  }
  
  Template? get template {
    return _template;
  }
  
  List<RawData>? get rawData {
    return _rawData;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Tree._internal({required this.id, required name, status, project, template, rawData, createdAt, updatedAt}): _name = name, _status = status, _project = project, _template = template, _rawData = rawData, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Tree({String? id, required String name, String? status, Project? project, Template? template, List<RawData>? rawData}) {
    return Tree._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      status: status,
      project: project,
      template: template,
      rawData: rawData != null ? List<RawData>.unmodifiable(rawData) : rawData);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tree &&
      id == other.id &&
      _name == other._name &&
      _status == other._status &&
      _project == other._project &&
      _template == other._template &&
      DeepCollectionEquality().equals(_rawData, other._rawData);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Tree {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("project=" + (_project != null ? _project!.toString() : "null") + ", ");
    buffer.write("template=" + (_template != null ? _template!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Tree copyWith({String? name, String? status, Project? project, Template? template, List<RawData>? rawData}) {
    return Tree._internal(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      project: project ?? this.project,
      template: template ?? this.template,
      rawData: rawData ?? this.rawData);
  }
  
  Tree copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? status,
    ModelFieldValue<Project?>? project,
    ModelFieldValue<Template?>? template,
    ModelFieldValue<List<RawData>?>? rawData
  }) {
    return Tree._internal(
      id: id,
      name: name == null ? this.name : name.value,
      status: status == null ? this.status : status.value,
      project: project == null ? this.project : project.value,
      template: template == null ? this.template : template.value,
      rawData: rawData == null ? this.rawData : rawData.value
    );
  }
  
  Tree.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _status = json['status'],
      _project = json['project'] != null
        ? json['project']['serializedData'] != null
          ? Project.fromJson(new Map<String, dynamic>.from(json['project']['serializedData']))
          : Project.fromJson(new Map<String, dynamic>.from(json['project']))
        : null,
      _template = json['template'] != null
        ? json['template']['serializedData'] != null
          ? Template.fromJson(new Map<String, dynamic>.from(json['template']['serializedData']))
          : Template.fromJson(new Map<String, dynamic>.from(json['template']))
        : null,
      _rawData = json['rawData']  is Map
        ? (json['rawData']['items'] is List
          ? (json['rawData']['items'] as List)
              .where((e) => e != null)
              .map((e) => RawData.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['rawData'] is List
          ? (json['rawData'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => RawData.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'status': _status, 'project': _project?.toJson(), 'template': _template?.toJson(), 'rawData': _rawData?.map((RawData? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'status': _status,
    'project': _project,
    'template': _template,
    'rawData': _rawData,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TreeModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TreeModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final PROJECT = amplify_core.QueryField(
    fieldName: "project",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Project'));
  static final TEMPLATE = amplify_core.QueryField(
    fieldName: "template",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Template'));
  static final RAWDATA = amplify_core.QueryField(
    fieldName: "rawData",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RawData'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Tree";
    modelSchemaDefinition.pluralName = "Trees";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tree.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tree.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Tree.PROJECT,
      isRequired: false,
      targetNames: ['projectTreesId'],
      ofModelName: 'Project'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Tree.TEMPLATE,
      isRequired: false,
      targetNames: ['templateTreesId'],
      ofModelName: 'Template'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Tree.RAWDATA,
      isRequired: false,
      ofModelName: 'RawData',
      associatedKey: RawData.TREE
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

class _TreeModelType extends amplify_core.ModelType<Tree> {
  const _TreeModelType();
  
  @override
  Tree fromJson(Map<String, dynamic> jsonData) {
    return Tree.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Tree';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Tree] in your schema.
 */
class TreeModelIdentifier implements amplify_core.ModelIdentifier<Tree> {
  final String id;

  /** Create an instance of TreeModelIdentifier using [id] the primary key. */
  const TreeModelIdentifier({
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
  String toString() => 'TreeModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TreeModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}