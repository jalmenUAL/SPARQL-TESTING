import module namespace spt = "sparql_testing" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/tester_sparql.xq";
import module namespace xqowl="XQOWL" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/XQOWL_TESTING.xq";
 
 declare namespace owl="http://www.w3.org/2002/07/owl#";
declare namespace rdf ="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";


(: WRONG TYPE: RUNNING :)

let $query1 := "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>

SELECT ?event ?user2
WHERE {
               
              ?event socialnetwork:created_by ?user1 . 
              ?event  socialnetwork:likes ?user2 .
              ?user2 socialnetwork:invited_to ?event     
             
}"

 

(: INCONSISTENT QUERY: RUNNING :)

let $query2 := "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>

SELECT ?message1 
WHERE {
  ?message1 socialnetwork:sent_by ?user . 
  ?message1 socialnetwork:replied_by ?message1
             
             
}"

(: WRONG VARIABLE: RUNNING :)

let $query3 :=
"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?user ?event ?user2
WHERE {
           ?event socialnetwork:added_by ?user .
           ?event socialnetwork:date ?date .
           ?user socialnetwork:friend_of ?user2 .        
           ?user2 socialnetwork:age ?age .
           FILTER (?age > 40 &amp;&amp; ?date < '2017-01-01T00:00:00Z'^^xsd:dateTime) 
       }
      "
      
(: WRONG KNOWLEDGE AND INCOMPATIBLE FILTER CONDITIONS: CHANGE DATE < 2017. RUNNING  :)

let $query4 := "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
	            PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
	            PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>
              PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?event ?date
WHERE {
              ?event socialnetwork:date ?date . 
              socialnetwork:athleticswch socialnetwork:date ?date2
              FILTER(?date >= ?date2 &amp;&amp; ?date < '2017-01-01T00:00:00Z'^^xsd:dateTime ) 
              
}"
      
 
(: WRONG KNOWLEDGE AND COMPATIBLE FILTER CONDITIONS. RUNNING :)

let $query5 := "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?user  
 WHERE { ?user socialnetwork:name  ?name1 ;
             socialnetwork:age  ?age1 .
         socialnetwork:antonio socialnetwork:name  ?name2 ;
             socialnetwork:age  ?age2 .
         FILTER (  ?age1 > ?age2 &amp;&amp; ?name1 != ?name2)
       }"

 

let $query6 := "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX socialnetwork: <http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT ?event ?attendees ?likes WHERE {
    ?event socialnetwork:created_by ?user .
     
     
  {
    SELECT ?event (COUNT(?person) AS ?likes) WHERE {
      ?person socialnetwork:likes ?event .
       
    }
    GROUP BY ?event
  }
  UNION
  {
    SELECT ?event (COUNT(?person) AS ?attendees) WHERE {
      ?person socialnetwork:attends_to ?event
    }
    GROUP BY ?event
  }
}"
    
    
 
 
let $ontology := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/soc-net.owl"

let $schema1 := doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rXMLSchema_1c.xsd")

let $schema2 := doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rXMLSchema_2c.xsd")

let $schema3 := doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rXMLSchema_3c.xsd")

let $schema4 := doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rXMLSchema_4c.xsd")

let $schema5 := doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rXMLSchema_5c.xsd")

 

let $schema6 := doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rXMLSchema_6c.xsd")

let $property1 := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/Popular_event.owl"

let $property2 := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/Popular_message.owl"

let $property3a := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/Mature-Young.owl"

let $property3b := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/This_Year-Past.owl"

let $property4 := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/This_Year-Past.owl"

let $property5 := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/Mature-Young.owl"
 
 

let $property6 := "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/Popular_event.owl"
 
let $binds1 := ("event","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#Popular_event")

let $binds2 := ("message1","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#Popular_message")

let $binds3a:= ("user","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#Mature")

let $binds3b:= ("event","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#This_Year")


let $binds4 := ("event","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#This_Year")

let $binds5 := ("user","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#Young")


let $binds6 := ("event","http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#Popular_event") 


return


spt:tester($schema1,$query1,$ontology,$property1,$binds1,0,'socialnetwork')


 