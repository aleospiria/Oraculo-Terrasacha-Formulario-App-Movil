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

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'AccessDeadline.dart';
import 'AnalisisCuota.dart';
import 'AnalisisCuotasUsoDiario.dart';
import 'ApiCredential.dart';
import 'Calculation.dart';
import 'ConstructorFormula.dart';
import 'ConstructorFormulaCategoria.dart';
import 'ConstructorFormulaVariable.dart';
import 'ConstructorFormulaVariableRel.dart';
import 'ConsultaAnalisis.dart';
import 'ConsultaApi.dart';
import 'ConsultaEstado.dart';
import 'ConsultaWeb.dart';
import 'DispositivoIot.dart';
import 'Feature.dart';
import 'FormulaDeepLearning.dart';
import 'FormulaHistorial.dart';
import 'FormulaTeledeteccion.dart';
import 'GrupoIot.dart';
import 'IotSession.dart';
import 'MedicionIot.dart';
import 'ModelAI.dart';
import 'ModelPackage.dart';
import 'PermVersion.dart';
import 'Project.dart';
import 'Proyecto.dart';
import 'ProyectoLegacy.dart';
import 'RawData.dart';
import 'RelDispositivoGrupoIot.dart';
import 'RelGrupoIotProyecto.dart';
import 'RoutePermission.dart';
import 'SatelliteTopology.dart';
import 'SatelliteTopologyModelAI.dart';
import 'Template.dart';
import 'TemplateFeature.dart';
import 'Topology.dart';
import 'TopologyTree.dart';
import 'Tree.dart';
import 'UnitOfMeasure.dart';
import 'User.dart';
import 'UserModelPackage.dart';

export 'AccessDeadline.dart';
export 'AnalisisCuota.dart';
export 'AnalisisCuotasUsoDiario.dart';
export 'ApiCredential.dart';
export 'Calculation.dart';
export 'ConstructorFormula.dart';
export 'ConstructorFormulaCategoria.dart';
export 'ConstructorFormulaVariable.dart';
export 'ConstructorFormulaVariableRel.dart';
export 'ConsultaAnalisis.dart';
export 'ConsultaApi.dart';
export 'ConsultaEstado.dart';
export 'ConsultaWeb.dart';
export 'DispositivoIot.dart';
export 'EstadoConsulta.dart';
export 'EstadoDispositivo.dart';
export 'EstadoTipoActor.dart';
export 'Feature.dart';
export 'FormulaDeepLearning.dart';
export 'FormulaHistorial.dart';
export 'FormulaTeledeteccion.dart';
export 'GrupoIot.dart';
export 'IotSession.dart';
export 'MedicionIot.dart';
export 'ModelAI.dart';
export 'ModelPackage.dart';
export 'PermVersion.dart';
export 'Project.dart';
export 'Proyecto.dart';
export 'ProyectoLegacy.dart';
export 'RawData.dart';
export 'RelDispositivoGrupoIot.dart';
export 'RelGrupoIotProyecto.dart';
export 'RoutePermission.dart';
export 'SatelliteTopology.dart';
export 'SatelliteTopologyModelAI.dart';
export 'SourceType.dart';
export 'SubjectType.dart';
export 'Template.dart';
export 'TemplateFeature.dart';
export 'TipoDispositivo.dart';
export 'TipoFormula.dart';
export 'Topology.dart';
export 'TopologyTree.dart';
export 'Tree.dart';
export 'UnitOfMeasure.dart';
export 'User.dart';
export 'UserModelPackage.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "e94f7863569c1edeb211c051150a7669";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [AccessDeadline.schema, AnalisisCuota.schema, AnalisisCuotasUsoDiario.schema, ApiCredential.schema, Calculation.schema, ConstructorFormula.schema, ConstructorFormulaCategoria.schema, ConstructorFormulaVariable.schema, ConstructorFormulaVariableRel.schema, ConsultaAnalisis.schema, ConsultaApi.schema, ConsultaEstado.schema, ConsultaWeb.schema, DispositivoIot.schema, Feature.schema, FormulaDeepLearning.schema, FormulaHistorial.schema, FormulaTeledeteccion.schema, GrupoIot.schema, IotSession.schema, MedicionIot.schema, ModelAI.schema, ModelPackage.schema, PermVersion.schema, Project.schema, Proyecto.schema, ProyectoLegacy.schema, RawData.schema, RelDispositivoGrupoIot.schema, RelGrupoIotProyecto.schema, RoutePermission.schema, SatelliteTopology.schema, SatelliteTopologyModelAI.schema, Template.schema, TemplateFeature.schema, Topology.schema, TopologyTree.schema, Tree.schema, UnitOfMeasure.schema, User.schema, UserModelPackage.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "AccessDeadline":
        return AccessDeadline.classType;
      case "AnalisisCuota":
        return AnalisisCuota.classType;
      case "AnalisisCuotasUsoDiario":
        return AnalisisCuotasUsoDiario.classType;
      case "ApiCredential":
        return ApiCredential.classType;
      case "Calculation":
        return Calculation.classType;
      case "ConstructorFormula":
        return ConstructorFormula.classType;
      case "ConstructorFormulaCategoria":
        return ConstructorFormulaCategoria.classType;
      case "ConstructorFormulaVariable":
        return ConstructorFormulaVariable.classType;
      case "ConstructorFormulaVariableRel":
        return ConstructorFormulaVariableRel.classType;
      case "ConsultaAnalisis":
        return ConsultaAnalisis.classType;
      case "ConsultaApi":
        return ConsultaApi.classType;
      case "ConsultaEstado":
        return ConsultaEstado.classType;
      case "ConsultaWeb":
        return ConsultaWeb.classType;
      case "DispositivoIot":
        return DispositivoIot.classType;
      case "Feature":
        return Feature.classType;
      case "FormulaDeepLearning":
        return FormulaDeepLearning.classType;
      case "FormulaHistorial":
        return FormulaHistorial.classType;
      case "FormulaTeledeteccion":
        return FormulaTeledeteccion.classType;
      case "GrupoIot":
        return GrupoIot.classType;
      case "IotSession":
        return IotSession.classType;
      case "MedicionIot":
        return MedicionIot.classType;
      case "ModelAI":
        return ModelAI.classType;
      case "ModelPackage":
        return ModelPackage.classType;
      case "PermVersion":
        return PermVersion.classType;
      case "Project":
        return Project.classType;
      case "Proyecto":
        return Proyecto.classType;
      case "ProyectoLegacy":
        return ProyectoLegacy.classType;
      case "RawData":
        return RawData.classType;
      case "RelDispositivoGrupoIot":
        return RelDispositivoGrupoIot.classType;
      case "RelGrupoIotProyecto":
        return RelGrupoIotProyecto.classType;
      case "RoutePermission":
        return RoutePermission.classType;
      case "SatelliteTopology":
        return SatelliteTopology.classType;
      case "SatelliteTopologyModelAI":
        return SatelliteTopologyModelAI.classType;
      case "Template":
        return Template.classType;
      case "TemplateFeature":
        return TemplateFeature.classType;
      case "Topology":
        return Topology.classType;
      case "TopologyTree":
        return TopologyTree.classType;
      case "Tree":
        return Tree.classType;
      case "UnitOfMeasure":
        return UnitOfMeasure.classType;
      case "User":
        return User.classType;
      case "UserModelPackage":
        return UserModelPackage.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
