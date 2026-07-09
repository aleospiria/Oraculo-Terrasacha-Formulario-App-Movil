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


/** This is an auto generated class representing the FormulaDeepLearning type in your schema. */
class FormulaDeepLearning extends amplify_core.Model {
  static const classType = const _FormulaDeepLearningModelType();
  final String id;
  final String? _rutaModelo;
  final String? _rutaEtiquetas;
  final String? _parametrosJson;
  final ConstructorFormula? _formula;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  FormulaDeepLearningModelIdentifier get modelIdentifier {
      return FormulaDeepLearningModelIdentifier(
        id: id
      );
  }
  
  String get rutaModelo {
    try {
      return _rutaModelo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get rutaEtiquetas {
    try {
      return _rutaEtiquetas!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get parametrosJson {
    return _parametrosJson;
  }
  
  ConstructorFormula? get formula {
    return _formula;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const FormulaDeepLearning._internal({required this.id, required rutaModelo, required rutaEtiquetas, parametrosJson, formula, createdAt, updatedAt}): _rutaModelo = rutaModelo, _rutaEtiquetas = rutaEtiquetas, _parametrosJson = parametrosJson, _formula = formula, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory FormulaDeepLearning({String? id, required String rutaModelo, required String rutaEtiquetas, String? parametrosJson, ConstructorFormula? formula}) {
    return FormulaDeepLearning._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      rutaModelo: rutaModelo,
      rutaEtiquetas: rutaEtiquetas,
      parametrosJson: parametrosJson,
      formula: formula);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FormulaDeepLearning &&
      id == other.id &&
      _rutaModelo == other._rutaModelo &&
      _rutaEtiquetas == other._rutaEtiquetas &&
      _parametrosJson == other._parametrosJson &&
      _formula == other._formula;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("FormulaDeepLearning {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("rutaModelo=" + "$_rutaModelo" + ", ");
    buffer.write("rutaEtiquetas=" + "$_rutaEtiquetas" + ", ");
    buffer.write("parametrosJson=" + "$_parametrosJson" + ", ");
    buffer.write("formula=" + (_formula != null ? _formula!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  FormulaDeepLearning copyWith({String? rutaModelo, String? rutaEtiquetas, String? parametrosJson, ConstructorFormula? formula}) {
    return FormulaDeepLearning._internal(
      id: id,
      rutaModelo: rutaModelo ?? this.rutaModelo,
      rutaEtiquetas: rutaEtiquetas ?? this.rutaEtiquetas,
      parametrosJson: parametrosJson ?? this.parametrosJson,
      formula: formula ?? this.formula);
  }
  
  FormulaDeepLearning copyWithModelFieldValues({
    ModelFieldValue<String>? rutaModelo,
    ModelFieldValue<String>? rutaEtiquetas,
    ModelFieldValue<String?>? parametrosJson,
    ModelFieldValue<ConstructorFormula?>? formula
  }) {
    return FormulaDeepLearning._internal(
      id: id,
      rutaModelo: rutaModelo == null ? this.rutaModelo : rutaModelo.value,
      rutaEtiquetas: rutaEtiquetas == null ? this.rutaEtiquetas : rutaEtiquetas.value,
      parametrosJson: parametrosJson == null ? this.parametrosJson : parametrosJson.value,
      formula: formula == null ? this.formula : formula.value
    );
  }
  
  FormulaDeepLearning.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _rutaModelo = json['rutaModelo'],
      _rutaEtiquetas = json['rutaEtiquetas'],
      _parametrosJson = json['parametrosJson'],
      _formula = json['formula'] != null
        ? json['formula']['serializedData'] != null
          ? ConstructorFormula.fromJson(new Map<String, dynamic>.from(json['formula']['serializedData']))
          : ConstructorFormula.fromJson(new Map<String, dynamic>.from(json['formula']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'rutaModelo': _rutaModelo, 'rutaEtiquetas': _rutaEtiquetas, 'parametrosJson': _parametrosJson, 'formula': _formula?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'rutaModelo': _rutaModelo,
    'rutaEtiquetas': _rutaEtiquetas,
    'parametrosJson': _parametrosJson,
    'formula': _formula,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<FormulaDeepLearningModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<FormulaDeepLearningModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final RUTAMODELO = amplify_core.QueryField(fieldName: "rutaModelo");
  static final RUTAETIQUETAS = amplify_core.QueryField(fieldName: "rutaEtiquetas");
  static final PARAMETROSJSON = amplify_core.QueryField(fieldName: "parametrosJson");
  static final FORMULA = amplify_core.QueryField(
    fieldName: "formula",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConstructorFormula'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "FormulaDeepLearning";
    modelSchemaDefinition.pluralName = "FormulaDeepLearnings";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["formulaId"], name: "byFormula")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaDeepLearning.RUTAMODELO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaDeepLearning.RUTAETIQUETAS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaDeepLearning.PARAMETROSJSON,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: FormulaDeepLearning.FORMULA,
      isRequired: false,
      targetNames: ['formulaId'],
      ofModelName: 'ConstructorFormula'
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

class _FormulaDeepLearningModelType extends amplify_core.ModelType<FormulaDeepLearning> {
  const _FormulaDeepLearningModelType();
  
  @override
  FormulaDeepLearning fromJson(Map<String, dynamic> jsonData) {
    return FormulaDeepLearning.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'FormulaDeepLearning';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [FormulaDeepLearning] in your schema.
 */
class FormulaDeepLearningModelIdentifier implements amplify_core.ModelIdentifier<FormulaDeepLearning> {
  final String id;

  /** Create an instance of FormulaDeepLearningModelIdentifier using [id] the primary key. */
  const FormulaDeepLearningModelIdentifier({
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
  String toString() => 'FormulaDeepLearningModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is FormulaDeepLearningModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}