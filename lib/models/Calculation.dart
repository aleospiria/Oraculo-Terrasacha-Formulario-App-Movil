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


/** This is an auto generated class representing the Calculation type in your schema. */
class Calculation extends amplify_core.Model {
  static const classType = const _CalculationModelType();
  final String id;
  final String? _polygon;
  final amplify_core.TemporalTimestamp? _start_date;
  final amplify_core.TemporalTimestamp? _end_date;
  final String? _satellite_TIF;
  final String? _result_TIF;
  final String? _result_PNG;
  final bool? _is_to_block_chain;
  final ModelAI? _modelAI;
  final User? _user;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CalculationModelIdentifier get modelIdentifier {
      return CalculationModelIdentifier(
        id: id
      );
  }
  
  String get polygon {
    try {
      return _polygon!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalTimestamp get start_date {
    try {
      return _start_date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalTimestamp get end_date {
    try {
      return _end_date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get satellite_TIF {
    try {
      return _satellite_TIF!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get result_TIF {
    try {
      return _result_TIF!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get result_PNG {
    try {
      return _result_PNG!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get is_to_block_chain {
    try {
      return _is_to_block_chain!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ModelAI? get modelAI {
    return _modelAI;
  }
  
  User? get user {
    return _user;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Calculation._internal({required this.id, required polygon, required start_date, required end_date, required satellite_TIF, required result_TIF, required result_PNG, required is_to_block_chain, modelAI, user, createdAt, updatedAt}): _polygon = polygon, _start_date = start_date, _end_date = end_date, _satellite_TIF = satellite_TIF, _result_TIF = result_TIF, _result_PNG = result_PNG, _is_to_block_chain = is_to_block_chain, _modelAI = modelAI, _user = user, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Calculation({String? id, required String polygon, required amplify_core.TemporalTimestamp start_date, required amplify_core.TemporalTimestamp end_date, required String satellite_TIF, required String result_TIF, required String result_PNG, required bool is_to_block_chain, ModelAI? modelAI, User? user}) {
    return Calculation._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      polygon: polygon,
      start_date: start_date,
      end_date: end_date,
      satellite_TIF: satellite_TIF,
      result_TIF: result_TIF,
      result_PNG: result_PNG,
      is_to_block_chain: is_to_block_chain,
      modelAI: modelAI,
      user: user);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Calculation &&
      id == other.id &&
      _polygon == other._polygon &&
      _start_date == other._start_date &&
      _end_date == other._end_date &&
      _satellite_TIF == other._satellite_TIF &&
      _result_TIF == other._result_TIF &&
      _result_PNG == other._result_PNG &&
      _is_to_block_chain == other._is_to_block_chain &&
      _modelAI == other._modelAI &&
      _user == other._user;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Calculation {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("polygon=" + "$_polygon" + ", ");
    buffer.write("start_date=" + (_start_date != null ? _start_date!.toString() : "null") + ", ");
    buffer.write("end_date=" + (_end_date != null ? _end_date!.toString() : "null") + ", ");
    buffer.write("satellite_TIF=" + "$_satellite_TIF" + ", ");
    buffer.write("result_TIF=" + "$_result_TIF" + ", ");
    buffer.write("result_PNG=" + "$_result_PNG" + ", ");
    buffer.write("is_to_block_chain=" + (_is_to_block_chain != null ? _is_to_block_chain!.toString() : "null") + ", ");
    buffer.write("modelAI=" + (_modelAI != null ? _modelAI!.toString() : "null") + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Calculation copyWith({String? polygon, amplify_core.TemporalTimestamp? start_date, amplify_core.TemporalTimestamp? end_date, String? satellite_TIF, String? result_TIF, String? result_PNG, bool? is_to_block_chain, ModelAI? modelAI, User? user}) {
    return Calculation._internal(
      id: id,
      polygon: polygon ?? this.polygon,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      satellite_TIF: satellite_TIF ?? this.satellite_TIF,
      result_TIF: result_TIF ?? this.result_TIF,
      result_PNG: result_PNG ?? this.result_PNG,
      is_to_block_chain: is_to_block_chain ?? this.is_to_block_chain,
      modelAI: modelAI ?? this.modelAI,
      user: user ?? this.user);
  }
  
  Calculation copyWithModelFieldValues({
    ModelFieldValue<String>? polygon,
    ModelFieldValue<amplify_core.TemporalTimestamp>? start_date,
    ModelFieldValue<amplify_core.TemporalTimestamp>? end_date,
    ModelFieldValue<String>? satellite_TIF,
    ModelFieldValue<String>? result_TIF,
    ModelFieldValue<String>? result_PNG,
    ModelFieldValue<bool>? is_to_block_chain,
    ModelFieldValue<ModelAI?>? modelAI,
    ModelFieldValue<User?>? user
  }) {
    return Calculation._internal(
      id: id,
      polygon: polygon == null ? this.polygon : polygon.value,
      start_date: start_date == null ? this.start_date : start_date.value,
      end_date: end_date == null ? this.end_date : end_date.value,
      satellite_TIF: satellite_TIF == null ? this.satellite_TIF : satellite_TIF.value,
      result_TIF: result_TIF == null ? this.result_TIF : result_TIF.value,
      result_PNG: result_PNG == null ? this.result_PNG : result_PNG.value,
      is_to_block_chain: is_to_block_chain == null ? this.is_to_block_chain : is_to_block_chain.value,
      modelAI: modelAI == null ? this.modelAI : modelAI.value,
      user: user == null ? this.user : user.value
    );
  }
  
  Calculation.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _polygon = json['polygon'],
      _start_date = json['start_date'] != null ? amplify_core.TemporalTimestamp.fromSeconds(json['start_date']) : null,
      _end_date = json['end_date'] != null ? amplify_core.TemporalTimestamp.fromSeconds(json['end_date']) : null,
      _satellite_TIF = json['satellite_TIF'],
      _result_TIF = json['result_TIF'],
      _result_PNG = json['result_PNG'],
      _is_to_block_chain = json['is_to_block_chain'],
      _modelAI = json['modelAI'] != null
        ? json['modelAI']['serializedData'] != null
          ? ModelAI.fromJson(new Map<String, dynamic>.from(json['modelAI']['serializedData']))
          : ModelAI.fromJson(new Map<String, dynamic>.from(json['modelAI']))
        : null,
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'polygon': _polygon, 'start_date': _start_date?.toSeconds(), 'end_date': _end_date?.toSeconds(), 'satellite_TIF': _satellite_TIF, 'result_TIF': _result_TIF, 'result_PNG': _result_PNG, 'is_to_block_chain': _is_to_block_chain, 'modelAI': _modelAI?.toJson(), 'user': _user?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'polygon': _polygon,
    'start_date': _start_date,
    'end_date': _end_date,
    'satellite_TIF': _satellite_TIF,
    'result_TIF': _result_TIF,
    'result_PNG': _result_PNG,
    'is_to_block_chain': _is_to_block_chain,
    'modelAI': _modelAI,
    'user': _user,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CalculationModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CalculationModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final POLYGON = amplify_core.QueryField(fieldName: "polygon");
  static final START_DATE = amplify_core.QueryField(fieldName: "start_date");
  static final END_DATE = amplify_core.QueryField(fieldName: "end_date");
  static final SATELLITE_TIF = amplify_core.QueryField(fieldName: "satellite_TIF");
  static final RESULT_TIF = amplify_core.QueryField(fieldName: "result_TIF");
  static final RESULT_PNG = amplify_core.QueryField(fieldName: "result_PNG");
  static final IS_TO_BLOCK_CHAIN = amplify_core.QueryField(fieldName: "is_to_block_chain");
  static final MODELAI = amplify_core.QueryField(
    fieldName: "modelAI",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ModelAI'));
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Calculation";
    modelSchemaDefinition.pluralName = "Calculations";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.POLYGON,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.START_DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.END_DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.SATELLITE_TIF,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.RESULT_TIF,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.RESULT_PNG,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Calculation.IS_TO_BLOCK_CHAIN,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Calculation.MODELAI,
      isRequired: false,
      targetNames: ['modelAICalculationsId'],
      ofModelName: 'ModelAI'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Calculation.USER,
      isRequired: false,
      targetNames: ['userCalculationsId'],
      ofModelName: 'User'
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

class _CalculationModelType extends amplify_core.ModelType<Calculation> {
  const _CalculationModelType();
  
  @override
  Calculation fromJson(Map<String, dynamic> jsonData) {
    return Calculation.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Calculation';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Calculation] in your schema.
 */
class CalculationModelIdentifier implements amplify_core.ModelIdentifier<Calculation> {
  final String id;

  /** Create an instance of CalculationModelIdentifier using [id] the primary key. */
  const CalculationModelIdentifier({
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
  String toString() => 'CalculationModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CalculationModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}