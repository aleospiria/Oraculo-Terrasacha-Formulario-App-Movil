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


/** This is an auto generated class representing the Topology type in your schema. */
class Topology extends amplify_core.Model {
  static const classType = const _TopologyModelType();
  final String id;
  final String? _name;
  final String? _string_code;
  final String? _number_code;
  final String? _status;
  final Project? _project;
  final Topology? _topologyParent;
  final List<Topology>? _topologies;
  final List<TopologyTree>? _topologyTrees;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TopologyModelIdentifier get modelIdentifier {
      return TopologyModelIdentifier(
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
  
  String? get string_code {
    return _string_code;
  }
  
  String? get number_code {
    return _number_code;
  }
  
  String? get status {
    return _status;
  }
  
  Project? get project {
    return _project;
  }
  
  Topology? get topologyParent {
    return _topologyParent;
  }
  
  List<Topology>? get topologies {
    return _topologies;
  }
  
  List<TopologyTree>? get topologyTrees {
    return _topologyTrees;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Topology._internal({required this.id, required name, string_code, number_code, status, project, topologyParent, topologies, topologyTrees, createdAt, updatedAt}): _name = name, _string_code = string_code, _number_code = number_code, _status = status, _project = project, _topologyParent = topologyParent, _topologies = topologies, _topologyTrees = topologyTrees, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Topology({String? id, required String name, String? string_code, String? number_code, String? status, Project? project, Topology? topologyParent, List<Topology>? topologies, List<TopologyTree>? topologyTrees}) {
    return Topology._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      string_code: string_code,
      number_code: number_code,
      status: status,
      project: project,
      topologyParent: topologyParent,
      topologies: topologies != null ? List<Topology>.unmodifiable(topologies) : topologies,
      topologyTrees: topologyTrees != null ? List<TopologyTree>.unmodifiable(topologyTrees) : topologyTrees);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Topology &&
      id == other.id &&
      _name == other._name &&
      _string_code == other._string_code &&
      _number_code == other._number_code &&
      _status == other._status &&
      _project == other._project &&
      _topologyParent == other._topologyParent &&
      DeepCollectionEquality().equals(_topologies, other._topologies) &&
      DeepCollectionEquality().equals(_topologyTrees, other._topologyTrees);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Topology {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("string_code=" + "$_string_code" + ", ");
    buffer.write("number_code=" + "$_number_code" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("project=" + (_project != null ? _project!.toString() : "null") + ", ");
    buffer.write("topologyParent=" + (_topologyParent != null ? _topologyParent!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Topology copyWith({String? name, String? string_code, String? number_code, String? status, Project? project, Topology? topologyParent, List<Topology>? topologies, List<TopologyTree>? topologyTrees}) {
    return Topology._internal(
      id: id,
      name: name ?? this.name,
      string_code: string_code ?? this.string_code,
      number_code: number_code ?? this.number_code,
      status: status ?? this.status,
      project: project ?? this.project,
      topologyParent: topologyParent ?? this.topologyParent,
      topologies: topologies ?? this.topologies,
      topologyTrees: topologyTrees ?? this.topologyTrees);
  }
  
  Topology copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? string_code,
    ModelFieldValue<String?>? number_code,
    ModelFieldValue<String?>? status,
    ModelFieldValue<Project?>? project,
    ModelFieldValue<Topology?>? topologyParent,
    ModelFieldValue<List<Topology>?>? topologies,
    ModelFieldValue<List<TopologyTree>?>? topologyTrees
  }) {
    return Topology._internal(
      id: id,
      name: name == null ? this.name : name.value,
      string_code: string_code == null ? this.string_code : string_code.value,
      number_code: number_code == null ? this.number_code : number_code.value,
      status: status == null ? this.status : status.value,
      project: project == null ? this.project : project.value,
      topologyParent: topologyParent == null ? this.topologyParent : topologyParent.value,
      topologies: topologies == null ? this.topologies : topologies.value,
      topologyTrees: topologyTrees == null ? this.topologyTrees : topologyTrees.value
    );
  }
  
  Topology.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _string_code = json['string_code'],
      _number_code = json['number_code'],
      _status = json['status'],
      _project = json['project'] != null
        ? json['project']['serializedData'] != null
          ? Project.fromJson(new Map<String, dynamic>.from(json['project']['serializedData']))
          : Project.fromJson(new Map<String, dynamic>.from(json['project']))
        : null,
      _topologyParent = json['topologyParent'] != null
        ? json['topologyParent']['serializedData'] != null
          ? Topology.fromJson(new Map<String, dynamic>.from(json['topologyParent']['serializedData']))
          : Topology.fromJson(new Map<String, dynamic>.from(json['topologyParent']))
        : null,
      _topologies = json['topologies']  is Map
        ? (json['topologies']['items'] is List
          ? (json['topologies']['items'] as List)
              .where((e) => e != null)
              .map((e) => Topology.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['topologies'] is List
          ? (json['topologies'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Topology.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _topologyTrees = json['topologyTrees']  is Map
        ? (json['topologyTrees']['items'] is List
          ? (json['topologyTrees']['items'] as List)
              .where((e) => e != null)
              .map((e) => TopologyTree.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['topologyTrees'] is List
          ? (json['topologyTrees'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => TopologyTree.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'string_code': _string_code, 'number_code': _number_code, 'status': _status, 'project': _project?.toJson(), 'topologyParent': _topologyParent?.toJson(), 'topologies': _topologies?.map((Topology? e) => e?.toJson()).toList(), 'topologyTrees': _topologyTrees?.map((TopologyTree? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'string_code': _string_code,
    'number_code': _number_code,
    'status': _status,
    'project': _project,
    'topologyParent': _topologyParent,
    'topologies': _topologies,
    'topologyTrees': _topologyTrees,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TopologyModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TopologyModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final STRING_CODE = amplify_core.QueryField(fieldName: "string_code");
  static final NUMBER_CODE = amplify_core.QueryField(fieldName: "number_code");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final PROJECT = amplify_core.QueryField(
    fieldName: "project",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Project'));
  static final TOPOLOGYPARENT = amplify_core.QueryField(
    fieldName: "topologyParent",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Topology'));
  static final TOPOLOGIES = amplify_core.QueryField(
    fieldName: "topologies",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Topology'));
  static final TOPOLOGYTREES = amplify_core.QueryField(
    fieldName: "topologyTrees",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'TopologyTree'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Topology";
    modelSchemaDefinition.pluralName = "Topologies";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Topology.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Topology.STRING_CODE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Topology.NUMBER_CODE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Topology.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Topology.PROJECT,
      isRequired: false,
      targetNames: ['projectTopologiesId'],
      ofModelName: 'Project'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Topology.TOPOLOGYPARENT,
      isRequired: false,
      targetNames: ['topologyTopologiesId'],
      ofModelName: 'Topology'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Topology.TOPOLOGIES,
      isRequired: false,
      ofModelName: 'Topology',
      associatedKey: Topology.TOPOLOGYPARENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Topology.TOPOLOGYTREES,
      isRequired: false,
      ofModelName: 'TopologyTree',
      associatedKey: TopologyTree.TOPOLOGY
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

class _TopologyModelType extends amplify_core.ModelType<Topology> {
  const _TopologyModelType();
  
  @override
  Topology fromJson(Map<String, dynamic> jsonData) {
    return Topology.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Topology';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Topology] in your schema.
 */
class TopologyModelIdentifier implements amplify_core.ModelIdentifier<Topology> {
  final String id;

  /** Create an instance of TopologyModelIdentifier using [id] the primary key. */
  const TopologyModelIdentifier({
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
  String toString() => 'TopologyModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TopologyModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}