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


/** This is an auto generated class representing the ModelAI type in your schema. */
class ModelAI extends amplify_core.Model {
  static const classType = const _ModelAIModelType();
  final String id;
  final String? _group;
  final String? _name;
  final String? _description;
  final String? _version;
  final String? _document_link;
  final bool? _is_latest;
  final String? _api_link;
  final bool? _is_approved;
  final int? _tokens_cost;
  final int? _cost_tokens;
  final ModelAI? _modelAIParent;
  final List<ModelAI>? _modelAIs;
  final List<Calculation>? _calculations;
  final List<SatelliteTopologyModelAI>? _satelliteTopologyModelAIs;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ModelAIModelIdentifier get modelIdentifier {
      return ModelAIModelIdentifier(
        id: id
      );
  }
  
  String? get group {
    return _group;
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
  
  String get version {
    try {
      return _version!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get document_link {
    try {
      return _document_link!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  String get api_link {
    try {
      return _api_link!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get is_approved {
    try {
      return _is_approved!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get tokens_cost {
    try {
      return _tokens_cost!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get cost_tokens {
    try {
      return _cost_tokens!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ModelAI? get modelAIParent {
    return _modelAIParent;
  }
  
  List<ModelAI>? get modelAIs {
    return _modelAIs;
  }
  
  List<Calculation>? get calculations {
    return _calculations;
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
  
  const ModelAI._internal({required this.id, group, required name, required description, required version, required document_link, required is_latest, required api_link, required is_approved, required tokens_cost, required cost_tokens, modelAIParent, modelAIs, calculations, satelliteTopologyModelAIs, createdAt, updatedAt}): _group = group, _name = name, _description = description, _version = version, _document_link = document_link, _is_latest = is_latest, _api_link = api_link, _is_approved = is_approved, _tokens_cost = tokens_cost, _cost_tokens = cost_tokens, _modelAIParent = modelAIParent, _modelAIs = modelAIs, _calculations = calculations, _satelliteTopologyModelAIs = satelliteTopologyModelAIs, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ModelAI({String? id, String? group, required String name, required String description, required String version, required String document_link, required bool is_latest, required String api_link, required bool is_approved, required int tokens_cost, required int cost_tokens, ModelAI? modelAIParent, List<ModelAI>? modelAIs, List<Calculation>? calculations, List<SatelliteTopologyModelAI>? satelliteTopologyModelAIs}) {
    return ModelAI._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      group: group,
      name: name,
      description: description,
      version: version,
      document_link: document_link,
      is_latest: is_latest,
      api_link: api_link,
      is_approved: is_approved,
      tokens_cost: tokens_cost,
      cost_tokens: cost_tokens,
      modelAIParent: modelAIParent,
      modelAIs: modelAIs != null ? List<ModelAI>.unmodifiable(modelAIs) : modelAIs,
      calculations: calculations != null ? List<Calculation>.unmodifiable(calculations) : calculations,
      satelliteTopologyModelAIs: satelliteTopologyModelAIs != null ? List<SatelliteTopologyModelAI>.unmodifiable(satelliteTopologyModelAIs) : satelliteTopologyModelAIs);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModelAI &&
      id == other.id &&
      _group == other._group &&
      _name == other._name &&
      _description == other._description &&
      _version == other._version &&
      _document_link == other._document_link &&
      _is_latest == other._is_latest &&
      _api_link == other._api_link &&
      _is_approved == other._is_approved &&
      _tokens_cost == other._tokens_cost &&
      _cost_tokens == other._cost_tokens &&
      _modelAIParent == other._modelAIParent &&
      DeepCollectionEquality().equals(_modelAIs, other._modelAIs) &&
      DeepCollectionEquality().equals(_calculations, other._calculations) &&
      DeepCollectionEquality().equals(_satelliteTopologyModelAIs, other._satelliteTopologyModelAIs);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ModelAI {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("group=" + "$_group" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("version=" + "$_version" + ", ");
    buffer.write("document_link=" + "$_document_link" + ", ");
    buffer.write("is_latest=" + (_is_latest != null ? _is_latest!.toString() : "null") + ", ");
    buffer.write("api_link=" + "$_api_link" + ", ");
    buffer.write("is_approved=" + (_is_approved != null ? _is_approved!.toString() : "null") + ", ");
    buffer.write("tokens_cost=" + (_tokens_cost != null ? _tokens_cost!.toString() : "null") + ", ");
    buffer.write("cost_tokens=" + (_cost_tokens != null ? _cost_tokens!.toString() : "null") + ", ");
    buffer.write("modelAIParent=" + (_modelAIParent != null ? _modelAIParent!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ModelAI copyWith({String? group, String? name, String? description, String? version, String? document_link, bool? is_latest, String? api_link, bool? is_approved, int? tokens_cost, int? cost_tokens, ModelAI? modelAIParent, List<ModelAI>? modelAIs, List<Calculation>? calculations, List<SatelliteTopologyModelAI>? satelliteTopologyModelAIs}) {
    return ModelAI._internal(
      id: id,
      group: group ?? this.group,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      document_link: document_link ?? this.document_link,
      is_latest: is_latest ?? this.is_latest,
      api_link: api_link ?? this.api_link,
      is_approved: is_approved ?? this.is_approved,
      tokens_cost: tokens_cost ?? this.tokens_cost,
      cost_tokens: cost_tokens ?? this.cost_tokens,
      modelAIParent: modelAIParent ?? this.modelAIParent,
      modelAIs: modelAIs ?? this.modelAIs,
      calculations: calculations ?? this.calculations,
      satelliteTopologyModelAIs: satelliteTopologyModelAIs ?? this.satelliteTopologyModelAIs);
  }
  
  ModelAI copyWithModelFieldValues({
    ModelFieldValue<String?>? group,
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? description,
    ModelFieldValue<String>? version,
    ModelFieldValue<String>? document_link,
    ModelFieldValue<bool>? is_latest,
    ModelFieldValue<String>? api_link,
    ModelFieldValue<bool>? is_approved,
    ModelFieldValue<int>? tokens_cost,
    ModelFieldValue<int>? cost_tokens,
    ModelFieldValue<ModelAI?>? modelAIParent,
    ModelFieldValue<List<ModelAI>?>? modelAIs,
    ModelFieldValue<List<Calculation>?>? calculations,
    ModelFieldValue<List<SatelliteTopologyModelAI>?>? satelliteTopologyModelAIs
  }) {
    return ModelAI._internal(
      id: id,
      group: group == null ? this.group : group.value,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      version: version == null ? this.version : version.value,
      document_link: document_link == null ? this.document_link : document_link.value,
      is_latest: is_latest == null ? this.is_latest : is_latest.value,
      api_link: api_link == null ? this.api_link : api_link.value,
      is_approved: is_approved == null ? this.is_approved : is_approved.value,
      tokens_cost: tokens_cost == null ? this.tokens_cost : tokens_cost.value,
      cost_tokens: cost_tokens == null ? this.cost_tokens : cost_tokens.value,
      modelAIParent: modelAIParent == null ? this.modelAIParent : modelAIParent.value,
      modelAIs: modelAIs == null ? this.modelAIs : modelAIs.value,
      calculations: calculations == null ? this.calculations : calculations.value,
      satelliteTopologyModelAIs: satelliteTopologyModelAIs == null ? this.satelliteTopologyModelAIs : satelliteTopologyModelAIs.value
    );
  }
  
  ModelAI.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _group = json['group'],
      _name = json['name'],
      _description = json['description'],
      _version = json['version'],
      _document_link = json['document_link'],
      _is_latest = json['is_latest'],
      _api_link = json['api_link'],
      _is_approved = json['is_approved'],
      _tokens_cost = (json['tokens_cost'] as num?)?.toInt(),
      _cost_tokens = (json['cost_tokens'] as num?)?.toInt(),
      _modelAIParent = json['modelAIParent'] != null
        ? json['modelAIParent']['serializedData'] != null
          ? ModelAI.fromJson(new Map<String, dynamic>.from(json['modelAIParent']['serializedData']))
          : ModelAI.fromJson(new Map<String, dynamic>.from(json['modelAIParent']))
        : null,
      _modelAIs = json['modelAIs']  is Map
        ? (json['modelAIs']['items'] is List
          ? (json['modelAIs']['items'] as List)
              .where((e) => e != null)
              .map((e) => ModelAI.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['modelAIs'] is List
          ? (json['modelAIs'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ModelAI.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _calculations = json['calculations']  is Map
        ? (json['calculations']['items'] is List
          ? (json['calculations']['items'] as List)
              .where((e) => e != null)
              .map((e) => Calculation.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['calculations'] is List
          ? (json['calculations'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Calculation.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
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
    'id': id, 'group': _group, 'name': _name, 'description': _description, 'version': _version, 'document_link': _document_link, 'is_latest': _is_latest, 'api_link': _api_link, 'is_approved': _is_approved, 'tokens_cost': _tokens_cost, 'cost_tokens': _cost_tokens, 'modelAIParent': _modelAIParent?.toJson(), 'modelAIs': _modelAIs?.map((ModelAI? e) => e?.toJson()).toList(), 'calculations': _calculations?.map((Calculation? e) => e?.toJson()).toList(), 'satelliteTopologyModelAIs': _satelliteTopologyModelAIs?.map((SatelliteTopologyModelAI? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'group': _group,
    'name': _name,
    'description': _description,
    'version': _version,
    'document_link': _document_link,
    'is_latest': _is_latest,
    'api_link': _api_link,
    'is_approved': _is_approved,
    'tokens_cost': _tokens_cost,
    'cost_tokens': _cost_tokens,
    'modelAIParent': _modelAIParent,
    'modelAIs': _modelAIs,
    'calculations': _calculations,
    'satelliteTopologyModelAIs': _satelliteTopologyModelAIs,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ModelAIModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ModelAIModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final GROUP = amplify_core.QueryField(fieldName: "group");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final VERSION = amplify_core.QueryField(fieldName: "version");
  static final DOCUMENT_LINK = amplify_core.QueryField(fieldName: "document_link");
  static final IS_LATEST = amplify_core.QueryField(fieldName: "is_latest");
  static final API_LINK = amplify_core.QueryField(fieldName: "api_link");
  static final IS_APPROVED = amplify_core.QueryField(fieldName: "is_approved");
  static final TOKENS_COST = amplify_core.QueryField(fieldName: "tokens_cost");
  static final COST_TOKENS = amplify_core.QueryField(fieldName: "cost_tokens");
  static final MODELAIPARENT = amplify_core.QueryField(
    fieldName: "modelAIParent",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ModelAI'));
  static final MODELAIS = amplify_core.QueryField(
    fieldName: "modelAIs",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ModelAI'));
  static final CALCULATIONS = amplify_core.QueryField(
    fieldName: "calculations",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Calculation'));
  static final SATELLITETOPOLOGYMODELAIS = amplify_core.QueryField(
    fieldName: "satelliteTopologyModelAIs",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SatelliteTopologyModelAI'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ModelAI";
    modelSchemaDefinition.pluralName = "ModelAIS";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.GROUP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.VERSION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.DOCUMENT_LINK,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.IS_LATEST,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.API_LINK,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.IS_APPROVED,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.TOKENS_COST,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelAI.COST_TOKENS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ModelAI.MODELAIPARENT,
      isRequired: false,
      targetNames: ['modelAIModelAIsId'],
      ofModelName: 'ModelAI'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ModelAI.MODELAIS,
      isRequired: false,
      ofModelName: 'ModelAI',
      associatedKey: ModelAI.MODELAIPARENT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ModelAI.CALCULATIONS,
      isRequired: false,
      ofModelName: 'Calculation',
      associatedKey: Calculation.MODELAI
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ModelAI.SATELLITETOPOLOGYMODELAIS,
      isRequired: false,
      ofModelName: 'SatelliteTopologyModelAI',
      associatedKey: SatelliteTopologyModelAI.MODELAI
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

class _ModelAIModelType extends amplify_core.ModelType<ModelAI> {
  const _ModelAIModelType();
  
  @override
  ModelAI fromJson(Map<String, dynamic> jsonData) {
    return ModelAI.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ModelAI';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ModelAI] in your schema.
 */
class ModelAIModelIdentifier implements amplify_core.ModelIdentifier<ModelAI> {
  final String id;

  /** Create an instance of ModelAIModelIdentifier using [id] the primary key. */
  const ModelAIModelIdentifier({
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
  String toString() => 'ModelAIModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ModelAIModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}