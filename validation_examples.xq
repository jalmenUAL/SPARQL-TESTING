import module namespace xqowl="XQOWL" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/XQOWL_VALIDATION.xq";
import module namespace xqo = "java:xqowl.XQOWL2";


let $query := "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
	            PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
	            PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>
              PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?event
WHERE {
              ?event socialnetwork:date ?date . 
              FILTER (?date < '2016-01-01T00:00:00Z'^^xsd:dateTime) .
              ?event socialnetwork:confirmed_by ?event
}"



return 
 
xqowl:validation('socialnetwork', '/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/sn-validation-2016.owl',$query)


 