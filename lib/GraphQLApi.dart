// services/graphql_api.dart
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLApi {
  final GraphQLClient client;
  GraphQLApi(this.client);

  Future<QueryResult> runMutation({
    required String document,
    Map<String, dynamic> variables = const {},
  }) {
    return client.mutate(
      MutationOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache, // para writes suele ser mejor
      ),
    );
  }

  Future<QueryResult> runQuery({
    required String document,
    Map<String, dynamic> variables = const {},
  }) {
    return client.query(
      QueryOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }
}