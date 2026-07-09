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


/** This is an auto generated class representing the ModelPackage type in your schema. */
class ModelPackage extends amplify_core.Model {
  static const classType = const _ModelPackageModelType();
  final String id;
  final int? _tokenAmount;
  final List<UserModelPackage>? _user_model_packages;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ModelPackageModelIdentifier get modelIdentifier {
      return ModelPackageModelIdentifier(
        id: id
      );
  }
  
  int get tokenAmount {
    try {
      return _tokenAmount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<UserModelPackage>? get user_model_packages {
    return _user_model_packages;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ModelPackage._internal({required this.id, required tokenAmount, user_model_packages, createdAt, updatedAt}): _tokenAmount = tokenAmount, _user_model_packages = user_model_packages, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ModelPackage({String? id, required int tokenAmount, List<UserModelPackage>? user_model_packages}) {
    return ModelPackage._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tokenAmount: tokenAmount,
      user_model_packages: user_model_packages != null ? List<UserModelPackage>.unmodifiable(user_model_packages) : user_model_packages);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModelPackage &&
      id == other.id &&
      _tokenAmount == other._tokenAmount &&
      DeepCollectionEquality().equals(_user_model_packages, other._user_model_packages);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ModelPackage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tokenAmount=" + (_tokenAmount != null ? _tokenAmount!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ModelPackage copyWith({int? tokenAmount, List<UserModelPackage>? user_model_packages}) {
    return ModelPackage._internal(
      id: id,
      tokenAmount: tokenAmount ?? this.tokenAmount,
      user_model_packages: user_model_packages ?? this.user_model_packages);
  }
  
  ModelPackage copyWithModelFieldValues({
    ModelFieldValue<int>? tokenAmount,
    ModelFieldValue<List<UserModelPackage>?>? user_model_packages
  }) {
    return ModelPackage._internal(
      id: id,
      tokenAmount: tokenAmount == null ? this.tokenAmount : tokenAmount.value,
      user_model_packages: user_model_packages == null ? this.user_model_packages : user_model_packages.value
    );
  }
  
  ModelPackage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tokenAmount = (json['tokenAmount'] as num?)?.toInt(),
      _user_model_packages = json['user_model_packages']  is Map
        ? (json['user_model_packages']['items'] is List
          ? (json['user_model_packages']['items'] as List)
              .where((e) => e != null)
              .map((e) => UserModelPackage.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['user_model_packages'] is List
          ? (json['user_model_packages'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => UserModelPackage.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tokenAmount': _tokenAmount, 'user_model_packages': _user_model_packages?.map((UserModelPackage? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tokenAmount': _tokenAmount,
    'user_model_packages': _user_model_packages,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ModelPackageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ModelPackageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TOKENAMOUNT = amplify_core.QueryField(fieldName: "tokenAmount");
  static final USER_MODEL_PACKAGES = amplify_core.QueryField(
    fieldName: "user_model_packages",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserModelPackage'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ModelPackage";
    modelSchemaDefinition.pluralName = "ModelPackages";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ModelPackage.TOKENAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ModelPackage.USER_MODEL_PACKAGES,
      isRequired: false,
      ofModelName: 'UserModelPackage',
      associatedKey: UserModelPackage.MODELPACKAGE
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

class _ModelPackageModelType extends amplify_core.ModelType<ModelPackage> {
  const _ModelPackageModelType();
  
  @override
  ModelPackage fromJson(Map<String, dynamic> jsonData) {
    return ModelPackage.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ModelPackage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ModelPackage] in your schema.
 */
class ModelPackageModelIdentifier implements amplify_core.ModelIdentifier<ModelPackage> {
  final String id;

  /** Create an instance of ModelPackageModelIdentifier using [id] the primary key. */
  const ModelPackageModelIdentifier({
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
  String toString() => 'ModelPackageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ModelPackageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}