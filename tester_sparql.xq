module namespace spt = "sparql_testing";
import module namespace tc = "test_cases" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/test_cases.xq";
import module namespace xqowl="XQOWL" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/XQOWL_TESTING.xq";
declare namespace rdf ="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace socialnetwork = "http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#";


declare function spt:clean($data)
{
  let $data2 := replace($data,"&lt;","")
let $data3 := replace($data2,"&gt;","")

return $data3
};

(: NEW_SCHEMAS :)

declare function spt:new_schemas($schema)
{
let $count := count($schema)
let $new := (for $k in 1 to $count return tc:increase($schema[$k]))
return $new              
};

(: TESTER: MAIN FUNCTION :)

declare function spt:tester($schema as node()*,$query as xs:string,$ontology as xs:string,$property,$binds,$i as xs:integer,$nameontology)
{ 
  
  
  let $sv := xqowl:syntactic-typing($ontology,$query)
  return
  if (empty($sv)) then
  let $sm := xqowl:semantic_typing($nameontology,$ontology,$query)
  return 
  if (empty($sm)) then
  spt:tester_loop(tc:unfold($schema),$query,$ontology,$property,$binds,0,$i,0,0,0)
  else $sm
  else $sv
  
 
};

(: TESTER_LOOP :)

declare function spt:tester_loop($schema as node()*,$query as xs:string,$ontology as xs:string,$property,$binds,$k as xs:integer, $i as xs:integer,$tests as xs:integer,$empties as xs:integer,$inconsistent )
{
if ($k>$i) then
  if ($tests=$empties+$inconsistent) then spt:show_unable($empties,$inconsistent)
  else spt:show_passed($tests,$empties,$inconsistent)
else 
spt:tester_schema($schema,$schema,$query,$ontology,$property,$binds,$k,$i,$tests,$empties,$inconsistent )
}; 

(: TESTER_SCHEMA :)

declare function spt:tester_schema($schemas as node()*,$all as node()*,$query as xs:string,$ontology,$property,$binds,$k as xs:integer,$i as xs:integer,$tests as xs:integer,$empties as xs:integer,$inconsistent )
{
  if (empty($schemas)) then let $new := spt:new_schemas($all)
                        return
                        spt:tester_loop($new,$query,$ontology,$property,$binds,$k + 1,$i,$tests,$empties,$inconsistent )
                       else 
                       let $sc := head($schemas)
                       let $structure := tc:skeleton($sc/xs:schema/xs:element,true())
                       let $examples := 
                       tc:populate($structure,tc:getTypes($structure),
                       tc:getVal($structure,$sc/xs:schema,tc:getTypesName($structure)))
                       
                       let $total := count($examples) return
                       if (not($total=0)) then
                       
                       
                       let $output := (for $valid in $examples
                       let $ex := <rdf:RDF>{doc($ontology)/rdf:RDF/* union $valid/*} </rdf:RDF>
                       let $d := file:create-dir("tmp")
                       let $file := file:write("tmp/tmp-ont.owl",$ex)                
                       let $result := xqowl:SPARQL("tmp/tmp-ont.owl",$query)
                       let $binding := xqowl:Binding2Class($result,$binds)
                       return
                       if (empty($binding)) then <empty/>
                       else 
                       let $preconsistent := xqowl:consistent($ontology,$valid/*)
                       return
                       if (not($preconsistent="true")) then <inconsistent/> 
                       else 
                       let $ex2 := <rdf:RDF>{doc($ontology)/rdf:RDF/* union doc($property)/rdf:RDF/* union $valid/*} </rdf:RDF>
                       let $d := file:create-dir("tmp")
                       let $file := file:write("tmp/tmp-ont2.owl",$ex2) 
                       let $consistent := xqowl:consistent_type("tmp/tmp-ont2.owl", $binding)  
                       return
                       if (not($consistent)) 
                       then <valid><counter>{$valid}</counter></valid>
                       else <good/>)
                       
                       let $counterexamples := $output[not(name(.)="empty") and not(name(.)="good")
                       and not(name(.)="inconsistent")]
                       
                       
                        
                       
                       let $numberofcounterexamples := count($counterexamples) 
                       
                       let $this_inconsistent := count($output[name(.)="inconsistent"])
                       
                        
                       
                      
                       let $newempties :=  count($output[name(.)="empty"])+$empties
                       
                       let $newinconsistent := $this_inconsistent + $inconsistent
                       
                       let $newtests := $tests + count($examples)
                        
                       return 
                       if ($numberofcounterexamples=0) then
                       
                       spt:tester_schema(tail($schemas),$all,$query,$ontology,$property,$binds,$k,$i,
                       $newtests,$newempties,$newinconsistent )
                      
                       else 
                        
                       spt:show_falsifiable_output($newtests,$counterexamples)
                       
                       else if ($tests=$empties+$inconsistent) then spt:show_unable($empties,$inconsistent)
                                     
                                           else spt:show_passed($tests,$empties,$inconsistent)
             
};


 

(: SHOW_PASSED :)

declare function spt:show_passed($tests,$empties,$inconsistent)
{
<Text>
Ok: passed {$tests} tests.
 
</Text>/text() 
};

(: Trivial: {$empties + $inconsistent} test.:)

(: SHOW_UNABLE :)

(:
<Text>
Unable to test the property. It was not possible to find consistent tests.
</Text>/text()
:)

declare function spt:show_unable($empties,$inconsistent)
{
if ($inconsistent>0)
then
<Text>
Unable to test the property. It was not possible to find consistent tests.
</Text>/text()
else
<Text>
Unable to test the property. It was not possible to find non trivial tests.
</Text>/text() 
};

(: SHOW_FALSIFIABLE :)

declare function spt:show_falsifiable_output($tests,$counter)
{

("&#10;",
"Output Property Falsifiable after", $tests, "tests.",
"&#10;",
for $count in $counter
return
(
"---------------",
"&#10;",
"Counterexample:",
"&#10;",
"---------------",
"&#10;",
$count/counter/*,
"&#10;"
)
)
};

 
 






