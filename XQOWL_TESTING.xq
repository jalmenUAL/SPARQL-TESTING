module namespace xqowl="XQOWL";
 
 

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rdfs="http://www.w3.org/2000/01/rdf-schema#";
declare namespace owl="http://www.w3.org/2002/07/owl#";
declare namespace om = "java:org.semanticweb.owlapi.model.OWLOntologyManager";
import module namespace xqo = "java:xqowl.XQOWL2";
 
declare namespace file2 = "java:java.io.File";
declare namespace api = "java:org.semanticweb.owlapi.apibinding.OWLManager";
declare namespace r = "java:org.semanticweb.owlapi.reasoner.OWLReasoner";
declare namespace sp="http://spinrdf.org/sp#";
declare namespace socialnetwork = "http://www.semanticweb.org/ontologies/2011/7/socialnetwork.owl#";




(: COMPONENT :)

declare function xqowl:component($namespace,$object,$query)
{
  
  if ($object/sp:varName) then (: VARIABLE :)
            let $uri := xqo:Uri($query,$namespace)
            return concat($uri,$object/sp:varName/text())
  else if ($object/@rdf:datatype) then (: DATATYPE :)
              concat($object/text(),concat('^^',
              concat("xsd:",substring-after($object/@rdf:datatype,'#'))))
  else if  
        ($object/@rdf:resource) then $object/@rdf:resource
        else
        (: STRING :) 
        concat($object/text(),concat('^^',"xsd:string")) 
        
}; 

(: PREDICATE :)

declare function xqowl:predicate($namespace,$object,$query)
{
  let $uri := substring-before($object/@rdf:resource,'#')
  let $namespaceprop := xqo:Namespace($query,concat($uri,'#'))
  return
  if ($object/sp:varName) then (: VARIABLE :)
          concat(concat($namespace,':'),$object/sp:varName/text())
          else (: NON VARIABLE :)
          concat(concat($namespaceprop,':'),substring-after($object/@rdf:resource,'#'))
}; 

(: RANGES PROPERTY OWL :)

declare function xqowl:rangesPropertyOWL($name)
{

data(
doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/owl-vocabulary.xml")//rdf:Property[@rdf:ID=$name]/rdfs:range/@rdf:resource)
  
};

(: DOMAINS PROPERTY OWL  :)

declare function xqowl:domainsPropertyOWL($name)
{

data(doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/owl-vocabulary.xml")//rdf:Property[@rdf:ID=$name]/rdfs:domain/@rdf:resource)
  
};

(: RANGES PROPERTY RDF :)

declare function xqowl:rangesPropertyRDF($name)
{

data(doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdf:Property[rdfs:label=$name]/rdfs:range/@rdf:resource)
  
};

(: DOMAINS PROPERTY RDF :)

declare function xqowl:domainsPropertyRDF($name)
{
data(
doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdf:Property[rdfs:label=$name]/rdfs:domain/@rdf:resource)
  
};


(: RANGESDATAPROPERTY :)

declare function xqowl:rangesDataProperty($file,$uri,$prop)
{

parse-xml(xqo:RangesDataProperty($file,$uri,$prop))
  
};

(: RANGESOBJECTPROPERTY :)

declare function xqowl:rangesObjectProperty($file,$uri,$prop)
{

parse-xml(xqo:RangesObjectProperty($file,$uri,$prop))
  
};

(: DOMAINSDATAPROPERTY :)

declare function xqowl:domainsDataProperty($file,$uri,$prop)
{

parse-xml(xqo:DomainsDataProperty($file,$uri,$prop))
  
};

(: DOMAINSOBJECTPROPERTY :)

declare function xqowl:domainsObjectProperty($file,$uri,$prop)
{

parse-xml(xqo:DomainsObjectProperty($file,$uri,$prop))
  
};

(: CLEAN :)

declare function xqowl:clean($data)
{
  let $data2 := replace($data,"&lt;","")
  let $data3 := replace($data2,"&gt;","")
      return $data3
};

(: VOCABULARY CLASSES :)

declare function xqowl:voc-class($name)
{
  xqowl:rdf-class($name) or xqowl:rdfs-class($name) or xqowl:owl-class($name)
};

(: VOCABULARY PROPERTIES :)

declare function xqowl:voc-property($name)
{
  xqowl:rdf-property($name) or xqowl:rdfs-property($name) or xqowl:owl-property($name)
};

 

(: OWL DATA PROPERTIES :)

declare function xqowl:owl-dataproperty($name)
{
  if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/owl-vocabulary.xml")//rdf:Property[@rdf:ID=$name and not(rdfs:range/@rdf:resource="http://www.w3.org/2000/01/rdf-schema#Resource")]) then true() else false()
};

(: RDF DATA PROPERTY :)

declare function xqowl:rdf-dataproperty($name)
{
  if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdf:Property[rdfs:label=$name and
rdfs:range/@rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"]) then true() else false()
};


(: RDF PROPERTY :)

declare function xqowl:rdf-property($name)
{
  if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdf:Property[rdfs:label=$name and
rdfs:isDefinedBy/@rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#"]) then true() else false()
   
};

(: RDF CLASS :)

declare function xqowl:rdf-class($name)
{
   if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdfs:Class[rdfs:label=$name and
rdfs:isDefinedBy/@rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#"]) then true() else false()
};

(: RDFS PROPERTY :)

declare function xqowl:rdfs-property($name)
{
    if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdf:Property[rdfs:label=$name
  and rdfs:isDefinedBy/@rdf:resource="http://www.w3.org/2000/01/rdf-schema#"]) then true() else false()
};

(: RDF CLASS :)

declare function xqowl:rdfs-class($name)
{
  if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/rdf-vocabulary.xml")//rdfs:Class[rdfs:label=$name
  and rdfs:isDefinedBy/@rdf:resource="http://www.w3.org/2000/01/rdf-schema#"]) then true() else false()
};

(: OWL PROPERTY :)

declare function xqowl:owl-property($name)
{
  if (doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/owl-vocabulary.xml")//rdf:Property[@rdf:ID=$name]) then true() else false()
};

(: OWL CLASS :)

declare function xqowl:owl-class($name)
{
  if ($name="Thing" or doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/ProyectoJesusAlmendros/TESTING/TESTING-SPARQL/owl-vocabulary.xml")//(rdfs:Class)[@rdf:ID=$name]) then true()
  else false()
};

(: PRINT :)

declare function xqowl:print($text)
{
  if (empty($text)) then ()
  else  if (empty(head($text))) then xqowl:print(tail($text))
  else (head($text),"&#10;",xqowl:print(tail($text)))
};

(: SPARQL TO SPIN :)

declare function xqowl:SPARQLtoSPIN($query)
{
let $res:= xqo:SPARQLtoSPIN($query)
return parse-xml($res)
}; 
 

(: SYNTACTIC TYPING :)


declare function xqowl:syntactic-typing($file,$query)
{
  xqowl:print((xqowl:type_object($file,$query),xqowl:type_subject($file,$query),
  xqowl:type_property($file,$query),xqowl:type_literals($file,$query),xqowl:type_filter($query)))
};



(: TYPE OF OBJECTS :)

declare function xqowl:type_object($file,$query)
{
   let $spin := xqowl:SPARQLtoSPIN($query)
  
  let $objects := $spin//rdf:Description/sp:object[@rdf:resource]
  
  for $object in $objects
  
  let $urio := concat(substring-before(data($object/@rdf:resource),'#'),'#')
  
  let $nameo := substring-after(data($object/@rdf:resource),'#')
  
  return 
  
  let $predicate := $object/../sp:predicate
  let $urip := concat(substring-before(data($predicate/@rdf:resource),'#'),'#')
  let $namep := substring-after(data($predicate/@rdf:resource),'#')
  return (: RESOURCE IN RDF/RDFS/OWL DATA PROPERTY :)
  if (xqowl:rdf-dataproperty($namep)) then
                  concat(concat("The element '",$namep),"' is not an object property")
  else (: RESOURCE IN DATA PROPERTY :)
  if (xqo:isDataProperty($file,$urip,$namep) and not(xqo:isObjectProperty($file,$urip,$namep)))
  then 
  concat(concat("The element '",$namep),"' is not an object property")
  else
  if ($urio = "http://www.w3.org/2000/01/rdf-schema#")
  then if (xqowl:rdfs-class($nameo)) then () else concat(concat("Wrong rdfs class '",$nameo),"'")
  else
  if ($urio = "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
  then if (xqowl:rdf-class($nameo)) then () else concat(concat("Wrong rdf class '",$nameo),"'")
  else
  if ($urio = "http://www.w3.org/2002/07/owl#")
  then if (xqowl:owl-class($nameo)) then () else concat(concat("Wrong owl class '",$nameo),"'")
  else
  if  (xqo:isClass($file,$urio,$nameo)) then ()
  else if  (xqo:isIndividual($file,$urio,$nameo)) then ()
  else if (xqo:isObjectProperty($file,$urio,$nameo)) then ()
  else if (xqo:isDataProperty($file,$urio,$nameo)) then ()
  else concat(concat("The element '",$nameo),"' does not exist") 
};

(: TYPE OF SUBJECTS :)

declare function xqowl:type_subject($file,$query)
{
   let $spin := xqowl:SPARQLtoSPIN($query)
  
  let $subjects := $spin//rdf:Description/sp:subject[@rdf:resource]
  
  for $subject in $subjects
  
  let $uri := concat(substring-before(data($subject/@rdf:resource),'#'),'#')
  
  let $name := substring-after(data($subject/@rdf:resource),'#')
  
  return 
  
  if ($uri = "http://www.w3.org/2000/01/rdf-schema#")
  then if (xqowl:rdfs-class($name)) then () else concat(concat("Wrong rdfs class '",$name),"'")
  else
  if ($uri = "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
  then if (xqowl:rdf-class($name)) then () else concat(concat("Wrong rdf class '",$name),"'")
  else
  if ($uri = "http://www.w3.org/2002/07/owl#")
  then if (xqowl:owl-class($name)) then () else concat(concat("Wrong owl class '",$name),"'")
  else
  
  if  (xqo:isClass($file,$uri,$name)) then ()
  else if  (xqo:isIndividual($file,$uri,$name)) then ()
  else if (xqo:isObjectProperty($file,$uri,$name)) then ()
  else if (xqo:isDataProperty($file,$uri,$name)) then ()
  else concat(concat("The element '",$name),"' does not exist")
};

(: TYPE OF PROPERTIES :)


declare function xqowl:type_property($file,$query)
{
  let $spin := xqowl:SPARQLtoSPIN($query)
  
  let $predicates := $spin//sp:predicate
  
  for $predicate in $predicates
  
  let $uri := concat(substring-before(data($predicate/@rdf:resource),'#'),'#')
  
  let $name := substring-after(data($predicate/@rdf:resource),'#')
  
  
  
  return 
  
  if ($predicate/sp:varName) then () 
  
  else
  
  if ($uri = "http://www.w3.org/2000/01/rdf-schema#")
  then if (xqowl:rdfs-property($name)) then () else concat(concat("Wrong rdfs property '",$name),"'")
  else
  if ($uri = "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
  then if (xqowl:rdf-property($name)) then () else concat(concat("Wrong rdf property '",$name),"'")
  else
  if ($uri = "http://www.w3.org/2002/07/owl#")
  then if (xqowl:owl-property($name)) then () else concat(concat("Wrong owl property '",$name),"'")
  else
  
  if  (xqo:isObjectProperty($file,$uri,$name)) then ()
  else if (xqo:isDataProperty($file,$uri,$name)) then ()
  else concat(concat("The property '",$name),"' does not exist")
  
  
};



(: TYPE OF FILTERS :)

declare function xqowl:type_filter($query)
{
for $f in 
    xqowl:SPARQLtoSPIN($query)//sp:Filter/sp:expression[sp:eq|sp:ne|sp:ge|sp:le|sp:gt|sp:lt]
return 
        if ($f/*/sp:arg1/@rdf:datatype and $f/*/sp:arg2/@rdf:datatype) 
        then 
            if ($f/*/sp:arg1/@rdf:datatype = $f/*/sp:arg2/@rdf:datatype) (: EQUAL DATATYPES :)
            then ()
            else concat(concat(concat("Wrong types in filter: ",
              substring-after($f/*/sp:arg1/@rdf:datatype,'#'))," and "),
              substring-after($f/*/sp:arg2/@rdf:datatype,'#'))
        else if ($f/*/sp:arg1[not (@rdf:datatype) and not (sp:varName)]  
        and $f/*/sp:arg2[not (@rdf:datatype) and not (sp:varName)]) (: EQUAL STRINGS :)
        then ()
        else 
        if ($f/*/sp:arg1[not (@rdf:datatype) and not (sp:varName)]  and 
            $f/*/sp:arg2/@rdf:datatype) (: STRING AND DATATYPE :)
            then
            concat("Wrong types in filter: string and ",
                      substring-after($f/*/sp:arg2/@rdf:datatype,'#'))
            else 
            if ($f/*/sp:arg2[not (@rdf:datatype) and not (sp:varName)]  and 
                $f/*/sp:arg1/@rdf:datatype) (: DATATYPE AND STRING :)
                then 
                concat("Wrong types in filter: string and ",
                  substring-after($f/*/sp:arg1/@rdf:datatype,'#'))
                else ()
};

(: TYPE OF LITERALS :)

declare function xqowl:type_literals($file,$query)
{
   let $spin := xqowl:SPARQLtoSPIN($query)
  
   let $objects := 
   $spin//rdf:Description/sp:object[@rdf:datatype or 
       (not(@rdf:resource) and not(@rdf:datatype) and not(sp:varName))]

    for $object in $objects
    
    let $predicate := $object/../sp:predicate
    let $uri := concat(substring-before(data($predicate/@rdf:resource),'#'),'#')
    let $name := substring-after(data($predicate/@rdf:resource),'#')
    
    return (: VOCABULARY DATAPROPERTY :)
    
    if ($uri = "http://www.w3.org/2002/07/owl#") then 
                   if (xqowl:owl-dataproperty($name)) then
                              
                         if (substring-after(xqowl:rangesPropertyOWL($name),'#')=
                         substring-after(data($object/@rdf:datatype),'#'))
                         then ()
                         else concat(concat("Wrong literal in datatype '",$name),"'")
                   else
                   concat(concat("The property '",$name),"' is not a data property")
                   else
                   if ($uri = "http://www.w3.org/1999/02/22-rdf-syntax-ns" 
                   or $uri ="http://www.w3.org/2000/01/rdf-schema" ) then 
                              if (xqowl:rdf-dataproperty($name)) then
                              
                              if (substring-after(xqowl:rangesPropertyRDF($name),'#')=
                              substring-after(data($object/@rdf:datatype),'#'))
                              then () 
                              else concat(concat("Wrong literal in datatype '",$name),"'")
                              else
                              concat(concat("The property '",$name),"' is not a data property")   
                           
                             
                              else (: USER DATAPROPERTY :)
                              if (xqo:isDataProperty($file,$uri,$name))
                             
                              
                              
                              then let $ranges := xqowl:rangesDataProperty($file,$uri,$name)/ranges/range/text()
                                    return if (some $r in $ranges satisfies 
                                          substring-after($r,'xsd:')=
                                          substring-after(data($object/@rdf:datatype),'#'))
                                    then ()
                                    
                                    else concat(concat("Wrong literal in datatype '",$name),"'")
                              
                              else concat(concat("The property '",$name),"' is not a data property")
                              
};





(: SEMANTIC TYPING :)

declare function xqowl:semantic_typing($namespace,$ont,$query)
{
let $ind := xqowl:type_triples($ont,$namespace,$query)
let $pv := xqowl:type_predicate_variables($namespace,$query)
let $fil := xqowl:type_filter($namespace,$query)


return let $newont :=  <rdf:RDF>{doc($ont)/rdf:RDF/* union $ind union $fil union $pv} </rdf:RDF>
let $d := file:create-dir("tmp")
let $file := file:write("tmp/validation.owl",$newont)
let $exp := xqo:allexplanations("tmp/validation.owl")
return 
      if ($exp="true") then () else 
      ("Test cases cannot be generated: &#10;",xqowl:clean($exp))

};


(: TYPE OF TRIPLES :)
 
declare function xqowl:type_triples($file,$namespace,$query)
{
let $uri := xqo:Uri($query,$namespace)


for $t in xqowl:SPARQLtoSPIN($query)//rdf:Description[not(sp:varName)]
let $name := substring-after(data($t/sp:predicate/@rdf:resource),'#')
return
 
            if (xqowl:rdf-dataproperty($name)) (: RDF DATA PROPERTY :)
            then
                if ($t/sp:object/@rdf:datatype) then  (: DATATYPE AND RDF DATA PROPERTY :)
                  (for $range in xqowl:rangesPropertyRDF($name)
                  return
                  <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                  <rdf:type rdf:resource="{$range}"/>  
                  </owl:Thing>)
                else 
            
                 (: STRING AND RDF DATA PROPERTY :)
                if ($t/sp:object[not(@rdf:resource) and not(@rdf:datatype) and not(sp:varName)]) then 
                  (for $range in xqowl:rangesPropertyRDF($name)
                  return
                  <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                  <rdf:type rdf:resource="{$range}"/> 
                  </owl:Thing>)
                else
                if ($t/sp:object[sp:varName])
                then
           (: VARIABLE AND RDF DATA PROPERTY :)  
            (for $range in xqowl:rangesPropertyRDF($name)
            return
            <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
            <rdf:type rdf:resource="{$range}"/> 
            </owl:Thing>)
            union
            (for $domain in xqowl:domainsPropertyRDF($name)
            return
            <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
            <rdf:type rdf:resource="{$domain}"/> 
            </owl:Thing>)
           else (:  NON LITERAL AND RDF OBJECT PROPERTY :)
          (for $range in xqowl:rangesPropertyRDF($name) return
          <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
          <rdf:type rdf:resource="{$range}"/> 
          </owl:Thing>)
          union
           (for $domain in xqowl:domainsPropertyRDF($name)
            return
          <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
          <rdf:type rdf:resource="{$domain}"/> 
          </owl:Thing>)
       
      
      else
       if (xqowl:owl-dataproperty($name)) (: OWL DATA PROPERTY :)
            then
                if ($t/sp:object/@rdf:datatype) then  (: DATATYPE AND OWL DATA PROPERTY :)
                  (for $range in xqowl:rangesPropertyOWL($name)
                  return
                  <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                  <rdf:type rdf:resource="{concat("http://www.w3.org/2002/07/owl",$range)}"/>  
                  </owl:Thing>)
                else 
            
                 (: STRING AND OWL DATA PROPERTY :)
                if ($t/sp:object[not(@rdf:resource) and not(@rdf:datatype) and not(sp:varName)]) then 
                  (for $range in xqowl:rangesPropertyOWL($name)
                  return
                  <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                  <rdf:type rdf:resource="{concat("http://www.w3.org/2002/07/owl",$range)}"/> 
                  </owl:Thing>)
          else
           if ($t/sp:object[sp:varName])
                then (: VARIABLE AND OWL DATA PROPERTY :)  
            (for $range in xqowl:rangesPropertyOWL($name)
            return
            <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
            <rdf:type rdf:resource="{concat("http://www.w3.org/2002/07/owl",$range)}"/> 
            </owl:Thing>)
            union
            (for $domain in xqowl:domainsPropertyOWL($name)
            return
            <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
            <rdf:type rdf:resource="{concat("http://www.w3.org/2002/07/owl",$domain)}"/> 
            </owl:Thing>)
        else (:  NON LITERAL AND OWL OBJECT PROPERTY :)
          (for $range in xqowl:rangesPropertyOWL($name) return
          <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
          <rdf:type rdf:resource="{concat("http://www.w3.org/2002/07/owl",$range)}"/> 
          </owl:Thing>)
          union
           (for $domain in xqowl:domainsPropertyOWL($name)
            return
          <owl:Thing  rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
          <rdf:type rdf:resource="{concat("http://www.w3.org/2002/07/owl",$domain)}"/> 
          </owl:Thing>)
            
            
      else (: VARIABLE AND DATA PROPERTY :)
        if ($t/sp:object/sp:varName and xqo:isDataProperty($file,
              concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
              substring-after($t/sp:predicate/@rdf:resource,'#'))
            and not(xqo:isObjectProperty($file,
              concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
              substring-after($t/sp:predicate/@rdf:resource,'#')))
              )
        then 
          
           (
          for $type in xqowl:rangesDataProperty($file,
            concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
            substring-after($t/sp:predicate/@rdf:resource,'#'))/ranges/range/text()
                 return 
                   <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
                     <rdf:type rdf:resource="{$type}"/> 
                   </owl:Thing>
                    )
                  union
                    (
                     for $type in xqowl:domainsDataProperty($file,
                     concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
                     substring-after($t/sp:predicate/@rdf:resource,'#'))/domains/domain/text()
                     return 
                     <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                       <rdf:type rdf:resource="{$type}"/> 
                     </owl:Thing> 
  
              ) 
              
          else (: VARIABLE AND OBJECT PROPERTY :)
           if ($t/sp:object/sp:varName and not(xqo:isDataProperty($file,
              concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
              substring-after($t/sp:predicate/@rdf:resource,'#')))
            and xqo:isObjectProperty($file,
              concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
              substring-after($t/sp:predicate/@rdf:resource,'#'))
              )
          
          then   
             (
          for $type in xqowl:rangesObjectProperty($file,
            concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
            substring-after($t/sp:predicate/@rdf:resource,'#'))/ranges/range/text()
                 return 
                   <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
                     <rdf:type rdf:resource="{$type}"/> 
                   </owl:Thing>
                    )
                  union
                    (
                     for $type in xqowl:domainsObjectProperty($file,
                     concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
                     substring-after($t/sp:predicate/@rdf:resource,'#'))/domains/domain/text()
                     return 
                     <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                       <rdf:type rdf:resource="{$type}"/> 
                     </owl:Thing> 
  
              ) 
               
           else (: VARIABLE AND OBJECT/DATA PROPERTY :)
           
              (
          for $type in xqowl:rangesDataProperty($file,
            concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
            substring-after($t/sp:predicate/@rdf:resource,'#'))/ranges/range/text()
                 return 
                   <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
                     <rdf:type rdf:resource="{$type}"/> 
                   </owl:Thing>
                    )
                  union
                    (
                     for $type in xqowl:domainsDataProperty($file,
                     concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
                     substring-after($t/sp:predicate/@rdf:resource,'#'))/domains/domain/text()
                     return 
                     <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                       <rdf:type rdf:resource="{$type}"/> 
                     </owl:Thing> 
  
            )
            union
                (
          for $type in xqowl:rangesObjectProperty($file,
            concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
            substring-after($t/sp:predicate/@rdf:resource,'#'))/ranges/range/text()
                 return 
                   <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:object,$query)}">
                     <rdf:type rdf:resource="{$type}"/> 
                   </owl:Thing>
                    )
                  union
                    (
                     for $type in xqowl:domainsObjectProperty($file,
                     concat(substring-before($t/sp:predicate/@rdf:resource,'#'),'#'),
                     substring-after($t/sp:predicate/@rdf:resource,'#'))/domains/domain/text()
                     return 
                     <owl:Thing rdf:about="{xqowl:component($namespace,$t/sp:subject,$query)}">
                       <rdf:type rdf:resource="{$type}"/> 
                     </owl:Thing> 
  
              )  
              
    
     
   
};

(: TYPE OF PREDICATE VARIABLES :)

declare function xqowl:type_predicate_variables($namespace,$query)
{
   let $spin := xqowl:SPARQLtoSPIN($query)
   let $uri := xqo:Uri($query,$namespace)
   let $predicates := 
   $spin//rdf:Description/sp:predicate[sp:varName]
   return
   for $predicate in $predicates
   return
   <owl:Thing rdf:about="{concat($uri,$predicate/sp:varName/text())}">
   <rdf:type rdf:resource="http://www.w3.org/2000/01/rdf-schema#Resource"/> 
   </owl:Thing>
};




(: TYPE OF FILTERS :)

declare function xqowl:type_filter($namespace,$query)
{
let $uri := xqo:Uri($query,$namespace)
for $f in xqowl:SPARQLtoSPIN($query)//sp:Filter/sp:expression[sp:eq|sp:ne|sp:ge|sp:le|sp:gt|sp:lt]
return 
        if ($f/*/sp:arg1/@rdf:datatype and $f/*/sp:arg2/sp:varName) (: DATATYPE AND VARIABLE :)
        then 
        <owl:Thing rdf:about="{concat($uri,$f/*/sp:arg2/sp:varName)}">
        <rdf:type rdf:resource="{$f/*/sp:arg1/@rdf:datatype}"/> 
        </owl:Thing>
else
      if (not($f/*/sp:arg1/@rdf:datatype) and not($f/*/sp:arg1/sp:varName) and 
      $f/*/sp:arg2/sp:varName)
      then (: STRING AND VARIABLE :) 
              <owl:Thing rdf:about="{concat($uri,$f/*/sp:arg2/sp:varName)}">
              <rdf:type rdf:resource="http://www.w3.org/2001/XMLSchema#string"/>
              </owl:Thing>
      else (: VARIABLE AND DATATYPE :)
            if ($f/*/sp:arg2/@rdf:datatype and $f/*/sp:arg1/sp:varName)
            then
            <owl:Thing rdf:about="{concat($uri,$f/*/sp:arg1/sp:varName)}">
            <rdf:type rdf:resource="{$f/*/sp:arg2/@rdf:datatype}"/> 
            </owl:Thing>
else (: VARIABLE AND STRING :)
          if (not($f/*/sp:arg2/@rdf:datatype) and not($f/*/sp:arg2/sp:varName) and 
          $f/*/sp:arg1/sp:varName)
          then 
              <owl:Thing rdf:about="{concat($uri,$f/*/sp:arg1/sp:varName)}">
                <rdf:type rdf:resource="http://www.w3.org/2001/XMLSchema#string"/>
              </owl:Thing>
           else if (($f/*/sp:arg1/sp:varName) and ($f/*/sp:arg2/sp:varName) and $f/(sp:ge|sp:le|sp:gt|sp:lt))
                then
                  <owl:Thing rdf:about="{concat($uri,$f/*/sp:arg1/sp:varName)}">
                    <rdf:type rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                  </owl:Thing>
                    union
                  <owl:Thing rdf:about="{concat($uri,$f/*/sp:arg2/sp:varName)}">
                    <rdf:type rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                  </owl:Thing>
                  else ()
};
 



(: SPARQL :)

declare function xqowl:SPARQL($fileName,$query)
{
let $res:= xqo:OWLSPARQL($fileName,$query) return parse-xml($res)
};


(: TESTING :)

declare function xqowl:consistent($model,$ontology)
{
let $newont :=  <rdf:RDF>{doc($model)/rdf:RDF/* union $ontology} </rdf:RDF>
let $d := file:create-dir("tmp")
let $file := file:write("tmp/testing.owl",$newont)
let $exp := xqo:consistent("tmp/testing.owl")  
return $exp   
};

declare function xqowl:consistent_type($ontology,$binding)
{

every $b in $binding satisfies xqowl:type($ontology,$b) 
 
};

declare function xqowl:type($ontology,$b)
{
let $item := data($b/@rdf:about)
let $type := data($b/rdf:type/@rdf:resource) 
return
some $inst in parse-xml(xqo:getInstances($ontology,$type))/instances/instance/text() 
satisfies $inst=$item
};


declare function xqowl:allexplanations($model,$ontology)
{
let $newont :=  <rdf:RDF>{doc($model)/rdf:RDF/* union $ontology} </rdf:RDF>
let $d := file:create-dir("tmp")
let $file := file:write("tmp/testing.owl",$newont)
let $exp := xqo:allexplanations("tmp/testing.owl")  
return $exp   
};

declare function xqowl:Result2Class($result,$var,$class)
{
  for $result in
  $result/*[name(.)="sparql"]/*[name(.)="results"]/*[name(.)="result"]
  for $binding in $result/*[name(.)="binding" and @name=$var]
  return
  
   for $uri in $binding/*[name(.)="uri"] 
   return
   <owl:Thing rdf:about="{$uri/text()}">
   <rdf:type rdf:resource="{$class}"/>
   </owl:Thing>
  
};

 


declare function xqowl:Binding2Class($res,$pairs)
{
  if (empty($pairs)) then ()
  else xqowl:Result2Class($res,head($pairs),head(tail($pairs)))
       union xqowl:Binding2Class($res,tail(tail($pairs)))
};


declare function xqowl:html($ontology,$query)
{
  let $result := xqowl:SPARQL($ontology,$query)
  return 
  
  <html>
  <body>
  <p>Results</p>
  <p>
  <table border="1">
  <tr>
  {for $variable in $result//*[name(.)="variable"]
  return <th>{data($variable/@name)}</th>}
  </tr>
  {
  for $result in $result//*[name(.)="result"]
  return
  <tr>{
  for $uri in $result/*[name(.)="binding"]/*[name(.)="uri"]
  return
  <td>{$uri/text()}</td>
  }</tr>
  }
  </table>
   </p>
  </body>
  </html>
};
 
 