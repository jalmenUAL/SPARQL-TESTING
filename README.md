# SPARQL-TESTING
PROPERTY BASED TESTING OF SPARQL QUERIES
Given a SPARQL query, the tool randomly generates test cases which consist on instances of an ontology. The tool checks the well typed-ness of the SPARQL query as well as the consistency of the test cases with the ontology axioms. Test cases are later used to execute the SPARQL query. The output of the SPARQL query is tested with a Boolean property which is defined in terms of membership of ontology individuals to ontology classes. The testing tool reports counterexamples when the Boolean property is not satisfied.
