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


/** This is an auto generated class representing the Template type in your schema. */
class Template extends amplify_core.Model {
  static const classType = const _TemplateModelType();
  final String id;
  final String? _name;
  final String? _description;
  final int? _type;
  final String? _version;
  final bool? _is_latest;
  final Template? _templateParent;
  final List<Template>? _templates;
  final List<TemplateFeature>? _templateFeatures;
  final List<Tree>? _trees;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TemplateModelIdentifier get modelIdentifier {
      return TemplateModelIdentifier(
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
  
  String? get description {
    return _description;
  }
  
  int get type {
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
  
  String? get version {
    return _version;
  }
  
  bool get is_latest {
    try {
      return _is_latest!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Template? get templateParent {
    return _templateParent;
  }
  
  List<Template>? get templates {
    return _templates;
  }
  
  List<TemplateFeature>? get templateFeatures {
    return _templateFeatures;
  }
  
  List<Tree>? get trees {
    return _trees;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Template._internal({required this.id, required name, description, required type, version, required is_latest, templateParent, templates, templateFeatures, trees, createdAt, updatedAt}): _name = name, _description = description, _type = type, _version = version, _is_latest = is_latest, _templateParent = templateParent, _templates = templates, _templateFeatures = templateFeatures, _trees = trees, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Template({String? id, required String name, String? description, required int type, String? version, required bool is_latest, Template? templateParent, List<Template>? templates, List<TemplateFeature>? templateFeatures, List<Tree>? trees}) {
    return Template._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      description: description,
      type: type,
      version: version,
      is_latest: is_latest,
      templateParent: templateParent,
      templates: templates != null ? List<Template>.unmodifiable(templates) : templates,
      templateFeatures: templateFeatures != null ? List<TemplateFeature>.unmodifiable(templateFeatures) : templateFeatures,
      trees: trees != null ? List<Tree>.unmodifiable(trees) : trees);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Template &&
      id == other.id &&
      _name == other._name &&
      _description == other._description &&
      _type == other._type &&
      _version == other._version &&
      _is_latest == other._is_latest &&
      _templateParent == other._templateParent &&
      DeepCollectionEquality().equals(_templates, other._templates) &&
      DeepCollectionEquality().equals(_templateFeatures, other._templateFeatures) &&
      DeepCollectionEquality().equals(_trees, other._trees);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Template {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("type=" + (_type != null ? _type!.toString() : "null") + ", ");
    buffer.write("version=" + "$_version" + ", ");
    buffer.write("is_latest=" + (_is_latest != null ? _is_latest!.toString() : "null") + ", ");
    buffer.write("templateParent=" + (_templateParent != null ? _templateParent!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Template copyWith({String? name, String? description, int? type, String? version, bool? is_latest, Template? templateParent, List<Template>? templates, List<TemplateFeature>? templateFeatures, List<Tree>? trees}) {
    return Template._internal(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      version: version ?? this.version,
      is_latest: is_latest ?? this.is_latest,
      templateParent: templateParent ?? this.templateParent,
      templates: templates ?? this.templates,
      templateFeatures: templateFeatures ?? this.templateFeatures,
      trees: trees ?? this.trees);
  }
  
  Template copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String?>? description,
    ModelFieldValue<int>? type,
    ModelFieldValue<String?>? version,
    ModelFieldValue<bool>? is_latest,
    ModelFieldValue<Template?>? templateParent,
    ModelFieldValue<List<Template>?>? templates,
    ModelFieldValue<List<TemplateFeature>?>? templateFeatures,
    ModelFieldValue<List<Tree>?>? trees
  }) {
    return Template._internal(
      id: id,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      type: type == null ? this.type : type.value,
      version: version == null ? this.version : version.value,
      is_latest: is_latest == null ? this.is_latest : is_latest.value,
      templateParent: templateParent == null ? this.templateParent : templateParent.value,
      templates: templates == null ? this.templates : templates.value,
      templateFeatures: templateFeatures == null ? this.templateFeatures : templateFeatures.value,
      trees: trees == null ? this.trees : trees.value
    );
  }
  
  Template.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _description = json['description'],
      _type = (json['type'] as num?)?.toInt(),
      _version = json['version'],
      _is_latest = json['is_latest'],
      _templateParent = json['templateParent'] != null
        ? json['templateParent']['serializedData'] != null
          ? Template.fromJson(new Map<String, dynamic>.from(json['templateParent']['serializedData']))
          : Template.fromJson(new Map<String, dynamic>.from(json['templateParent']))
        : null,
      _templates = json['templates']  is Map
        ? (json['templates']['items'] is List
          ? (json['templates']['items'] as List)
              .where((e) => e != null)
              .map((e) => Template.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['templates'] is List
          ? (json['templates'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Template.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
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
      _trees = json['trees']  is Map
        ? (json['trees']['items'] is List
          ? (json['trees']['items'] as List)
              .where((e) => e != null)
              .map((e) => Tree.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['trees'] is List
          ? (json['trees'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Tree.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'description': _description, 'type': _type, 'version': _version, 'is_latest': _is_latest, 'templateParent': _templateParent?.toJson(), 'templates': _templates?.map((Template? e) => e?.toJson()).toList(), 'templateFeatures': _templateFeatures?.map((TemplateFeature? e) => e?.toJson()).toList(), 'trees': _trees?.map((Tree? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'description': _description,
    'type': _type,
    'version': _version,
    'is_latest': _is_latest,
    'templateParent': _templateParent,
    'templates': _templates,
    'templateFeatures': _templateFeatures,
    'trees': _trees,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TemplateModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TemplateModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final VERSION = amplify_core.QueryField(fieldName: "version");
  static final IS_LATEST = amplify_core.QueryField(fieldName: "is_latest");
  static final TEMPLATEPARENT = amplify_core.QueryField(
    fieldName: "templateParent",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Template'));
  static final TEMPLATES = amplify_core.QueryField(
    fieldName: "templates",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Template'));
  static final TEMPLATEFEATURES = amplify_core.QueryField(
    fieldName: "templateFeatures",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'TemplateFeature'));
  static final TREES = amplify_core.QueryField(
    fieldName: "trees",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Tree'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Template";
    modelSchemaDefinition.pluralName = "Templates";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Template.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Template.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Template.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Template.VERSION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Template.IS_LATEST,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Template.TEMPLATEPARENT,
      isRequired: false,
      targetNames: ['templateTemplatesId'],
      ofModelName: 'Template'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Template.TEMPLATES,
      isRequired: false,
      ofModelName: 'Template',
      associatedKey: Template.TEMPLATEPARENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Template.TEMPLATEFEATURES,
      isRequired: false,
      ofModelName: 'TemplateFeature',
      associatedKey: TemplateFeature.TEMPLATE
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Template.TREES,
      isRequired: false,
      ofModelName: 'Tree',
      associatedKey: Tree.TEMPLATE
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

class _TemplateModelType extends amplify_core.ModelType<Template> {
  const _TemplateModelType();
  
  @override
  Template fromJson(Map<String, dynamic> jsonData) {
    return Template.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Template';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Template] in your schema.
 */
class TemplateModelIdentifier implements amplify_core.ModelIdentifier<Template> {
  final String id;

  /** Create an instance of TemplateModelIdentifier using [id] the primary key. */
  const TemplateModelIdentifier({
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
  String toString() => 'TemplateModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TemplateModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}