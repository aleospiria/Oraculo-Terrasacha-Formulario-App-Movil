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


/** This is an auto generated class representing the ConstructorFormulaVariable type in your schema. */
class ConstructorFormulaVariable extends amplify_core.Model {
  static const classType = const _ConstructorFormulaVariableModelType();
  final String id;
  final String? _nombre;
  final String? _simbolo;
  final String? _unidades;
  final String? _descripcion;
  final bool? _estado;
  final ConstructorFormulaCategoria? _categoria;
  final List<ConstructorFormulaVariableRel>? _formulas;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConstructorFormulaVariableModelIdentifier get modelIdentifier {
      return ConstructorFormulaVariableModelIdentifier(
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
  
  String get simbolo {
    try {
      return _simbolo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get unidades {
    try {
      return _unidades!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get descripcion {
    try {
      return _descripcion!;
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
  
  ConstructorFormulaCategoria? get categoria {
    return _categoria;
  }
  
  List<ConstructorFormulaVariableRel>? get formulas {
    return _formulas;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConstructorFormulaVariable._internal({required this.id, required nombre, required simbolo, required unidades, required descripcion, required estado, categoria, formulas, createdAt, updatedAt}): _nombre = nombre, _simbolo = simbolo, _unidades = unidades, _descripcion = descripcion, _estado = estado, _categoria = categoria, _formulas = formulas, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConstructorFormulaVariable({String? id, required String nombre, required String simbolo, required String unidades, required String descripcion, required bool estado, ConstructorFormulaCategoria? categoria, List<ConstructorFormulaVariableRel>? formulas}) {
    return ConstructorFormulaVariable._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      nombre: nombre,
      simbolo: simbolo,
      unidades: unidades,
      descripcion: descripcion,
      estado: estado,
      categoria: categoria,
      formulas: formulas != null ? List<ConstructorFormulaVariableRel>.unmodifiable(formulas) : formulas);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConstructorFormulaVariable &&
      id == other.id &&
      _nombre == other._nombre &&
      _simbolo == other._simbolo &&
      _unidades == other._unidades &&
      _descripcion == other._descripcion &&
      _estado == other._estado &&
      _categoria == other._categoria &&
      DeepCollectionEquality().equals(_formulas, other._formulas);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConstructorFormulaVariable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("nombre=" + "$_nombre" + ", ");
    buffer.write("simbolo=" + "$_simbolo" + ", ");
    buffer.write("unidades=" + "$_unidades" + ", ");
    buffer.write("descripcion=" + "$_descripcion" + ", ");
    buffer.write("estado=" + (_estado != null ? _estado!.toString() : "null") + ", ");
    buffer.write("categoria=" + (_categoria != null ? _categoria!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConstructorFormulaVariable copyWith({String? nombre, String? simbolo, String? unidades, String? descripcion, bool? estado, ConstructorFormulaCategoria? categoria, List<ConstructorFormulaVariableRel>? formulas}) {
    return ConstructorFormulaVariable._internal(
      id: id,
      nombre: nombre ?? this.nombre,
      simbolo: simbolo ?? this.simbolo,
      unidades: unidades ?? this.unidades,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      categoria: categoria ?? this.categoria,
      formulas: formulas ?? this.formulas);
  }
  
  ConstructorFormulaVariable copyWithModelFieldValues({
    ModelFieldValue<String>? nombre,
    ModelFieldValue<String>? simbolo,
    ModelFieldValue<String>? unidades,
    ModelFieldValue<String>? descripcion,
    ModelFieldValue<bool>? estado,
    ModelFieldValue<ConstructorFormulaCategoria?>? categoria,
    ModelFieldValue<List<ConstructorFormulaVariableRel>?>? formulas
  }) {
    return ConstructorFormulaVariable._internal(
      id: id,
      nombre: nombre == null ? this.nombre : nombre.value,
      simbolo: simbolo == null ? this.simbolo : simbolo.value,
      unidades: unidades == null ? this.unidades : unidades.value,
      descripcion: descripcion == null ? this.descripcion : descripcion.value,
      estado: estado == null ? this.estado : estado.value,
      categoria: categoria == null ? this.categoria : categoria.value,
      formulas: formulas == null ? this.formulas : formulas.value
    );
  }
  
  ConstructorFormulaVariable.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _nombre = json['nombre'],
      _simbolo = json['simbolo'],
      _unidades = json['unidades'],
      _descripcion = json['descripcion'],
      _estado = json['estado'],
      _categoria = json['categoria'] != null
        ? json['categoria']['serializedData'] != null
          ? ConstructorFormulaCategoria.fromJson(new Map<String, dynamic>.from(json['categoria']['serializedData']))
          : ConstructorFormulaCategoria.fromJson(new Map<String, dynamic>.from(json['categoria']))
        : null,
      _formulas = json['formulas']  is Map
        ? (json['formulas']['items'] is List
          ? (json['formulas']['items'] as List)
              .where((e) => e != null)
              .map((e) => ConstructorFormulaVariableRel.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['formulas'] is List
          ? (json['formulas'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ConstructorFormulaVariableRel.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': _nombre, 'simbolo': _simbolo, 'unidades': _unidades, 'descripcion': _descripcion, 'estado': _estado, 'categoria': _categoria?.toJson(), 'formulas': _formulas?.map((ConstructorFormulaVariableRel? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'nombre': _nombre,
    'simbolo': _simbolo,
    'unidades': _unidades,
    'descripcion': _descripcion,
    'estado': _estado,
    'categoria': _categoria,
    'formulas': _formulas,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConstructorFormulaVariableModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConstructorFormulaVariableModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NOMBRE = amplify_core.QueryField(fieldName: "nombre");
  static final SIMBOLO = amplify_core.QueryField(fieldName: "simbolo");
  static final UNIDADES = amplify_core.QueryField(fieldName: "unidades");
  static final DESCRIPCION = amplify_core.QueryField(fieldName: "descripcion");
  static final ESTADO = amplify_core.QueryField(fieldName: "estado");
  static final CATEGORIA = amplify_core.QueryField(
    fieldName: "categoria",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConstructorFormulaCategoria'));
  static final FORMULAS = amplify_core.QueryField(
    fieldName: "formulas",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConstructorFormulaVariableRel'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConstructorFormulaVariable";
    modelSchemaDefinition.pluralName = "ConstructorFormulaVariables";
    
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
      amplify_core.ModelIndex(fields: const ["nombre"], name: "byNombre"),
      amplify_core.ModelIndex(fields: const ["simbolo"], name: "bySimbolo"),
      amplify_core.ModelIndex(fields: const ["categoriaId"], name: "byCategoria")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaVariable.NOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaVariable.SIMBOLO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaVariable.UNIDADES,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaVariable.DESCRIPCION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormulaVariable.ESTADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ConstructorFormulaVariable.CATEGORIA,
      isRequired: false,
      targetNames: ['categoriaId'],
      ofModelName: 'ConstructorFormulaCategoria'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConstructorFormulaVariable.FORMULAS,
      isRequired: false,
      ofModelName: 'ConstructorFormulaVariableRel',
      associatedKey: ConstructorFormulaVariableRel.VARIABLE
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

class _ConstructorFormulaVariableModelType extends amplify_core.ModelType<ConstructorFormulaVariable> {
  const _ConstructorFormulaVariableModelType();
  
  @override
  ConstructorFormulaVariable fromJson(Map<String, dynamic> jsonData) {
    return ConstructorFormulaVariable.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConstructorFormulaVariable';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConstructorFormulaVariable] in your schema.
 */
class ConstructorFormulaVariableModelIdentifier implements amplify_core.ModelIdentifier<ConstructorFormulaVariable> {
  final String id;

  /** Create an instance of ConstructorFormulaVariableModelIdentifier using [id] the primary key. */
  const ConstructorFormulaVariableModelIdentifier({
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
  String toString() => 'ConstructorFormulaVariableModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConstructorFormulaVariableModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}