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


/** This is an auto generated class representing the ConstructorFormulaCategoria type in your schema. */
class ConstructorFormulaCategoria extends amplify_core.Model {
  static const classType = const _ConstructorFormulaCategoriaModelType();
  final String id;
  final String? _nombre;
  final bool? _estado;
  final List<ConstructorFormulaVariable>? _variables;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConstructorFormulaCategoriaModelIdentifier get modelIdentifier {
      return ConstructorFormulaCategoriaModelIdentifier(
        id: id
      );
  }
  
  String get nombre {
    try {
      return _nombre!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get estado {
    try {
      return _estado!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<ConstructorFormulaVariable>? get variables {
    return _variables;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConstructorFormulaCategoria._internal({required this.id, required nombre, required estado, variables, createdAt, updatedAt}): _nombre = nombre, _estado = estado, _variables = variables, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConstructorFormulaCategoria({String? id, required String nombre, required bool estado, List<ConstructorFormulaVariable>? variables}) {
    return ConstructorFormulaCategoria._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      nombre: nombre,
      estado: estado,
      variables: variables != null ? List<ConstructorFormulaVariable>.unmodifiable(variables) : variables);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConstructorFormulaCategoria &&
      id == other.id &&
      _nombre == other._nombre &&
      _estado == other._estado &&
      DeepCollectionEquality().equals(_variables, other._variables);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConstructorFormulaCategoria {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("nombre=" + "$_nombre" + ", ");
    buffer.write("estado=" + (_estado != null ? _estado!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConstructorFormulaCategoria copyWith({String? nombre, bool? estado, List<ConstructorFormulaVariable>? variables}) {
    return ConstructorFormulaCategoria._internal(
      id: id,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
      variables: variables ?? this.variables);
  }
  
  ConstructorFormulaCategoria copyWithModelFieldValues({
    ModelFieldValue<String>? nombre,
    ModelFieldValue<bool>? estado,
    ModelFieldValue<List<ConstructorFormulaVariable>?>? variables
  }) {
    return ConstructorFormulaCategoria._internal(
      id: id,
      nombre: nombre == null ? this.nombre : nombre.value,
      estado: estado == null ? this.estado : estado.value,
      variables: variables == null ? this.variables : variables.value
    );
  }
  
  ConstructorFormulaCategoria.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _nombre = json['nombre'],
      _estado = json['estado'],
      _variables = json['variables']  is Map
        ? (json['variables']['items'] is List
          ? (json['variables']['items'] as List)
              .where((e) => e != null)
              .map((e) => ConstructorFormulaVariable.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['variables'] is List
          ? (json['variables'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ConstructorFormulaVariable.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': _nombre, 'estado': _estado, 'variables': _variables?.map((ConstructorFormulaVariable? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'nombre': _nombre,
    'estado': _estado,
    'variables': _variables,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConstructorFormulaCategoriaModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConstructorFormulaCategoriaModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NOMBRE = amplify_core.QueryField(fieldName: "nombre");
  static final ESTADO = amplify_core.QueryField(fieldName: "estado");
  static final VARIABLES = amplify_core.QueryField(
    fieldName: "variables",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConstructorFormulaVariable'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConstructorFormulaCategoria";
    modelSchemaDefinition.pluralName = "ConstructorFormulaCategorias";
    
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
      amplify_core.ModelIndex(fields: const ["nombre"], name: "byNombre")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaCategoria.NOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaCategoria.ESTADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConstructorFormulaCategoria.VARIABLES,
      isRequired: false,
      ofModelName: 'ConstructorFormulaVariable',
      associatedKey: ConstructorFormulaVariable.CATEGORIA
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

class _ConstructorFormulaCategoriaModelType extends amplify_core.ModelType<ConstructorFormulaCategoria> {
  const _ConstructorFormulaCategoriaModelType();
  
  @override
  ConstructorFormulaCategoria fromJson(Map<String, dynamic> jsonData) {
    return ConstructorFormulaCategoria.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConstructorFormulaCategoria';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConstructorFormulaCategoria] in your schema.
 */
class ConstructorFormulaCategoriaModelIdentifier implements amplify_core.ModelIdentifier<ConstructorFormulaCategoria> {
  final String id;

  /** Create an instance of ConstructorFormulaCategoriaModelIdentifier using [id] the primary key. */
  const ConstructorFormulaCategoriaModelIdentifier({
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
  String toString() => 'ConstructorFormulaCategoriaModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConstructorFormulaCategoriaModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}