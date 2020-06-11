<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: text/xml; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
 
include_once '../config/Database.php';

function array_to_xml( $data, &$xml_data ) {
    foreach( $data as $key => $value ) {
        if( is_array($value) ) {
            if( is_numeric($key) ){
                $key = 'item'.$key; //dealing with <0/>..<n/> issues
            }
            $subnode = $xml_data->addChild($key);
            array_to_xml($value, $subnode);
        } else {
            $xml_data->addChild("$key",htmlspecialchars("$value"));
        }
     }
}

try{
    $database = new Database();
    $db = $database->getConnection();
    
    $data = simplexml_load_string(file_get_contents("php://input"));
    
    $rusID = $data->attributes()["rusID"];
    $coopID = $data->attributes()["coopID"];
    $nbrOut = $data->totals->nbrOut;
    $nbrServed = $data->totals->nbrServed;
    $region_type = $data->regions->attributes()["type"];
    //echo('CALL outage_insert('.$rusID.', '.$coopID.', '.$nbrOut.', '.$nbrServed.', '.$region_type.', @OID)');
    $qry = "CALL outage_insert('".$rusID."', '".$coopID."', '".$nbrOut."', '".$nbrServed."', '".$region_type."', @OID);";
    $rs = $db->query($qry); 
    $rs2 = $db->query("SELECT @OID as id");
    $row = $rs2->fetch_object();
    $outageid = $row->id;
    foreach($data->regions->region as $region)
      {
        $countyFIPSId = $region->countyFIPSId;
        $stateFIPSId = $region->stateFIPSId;
        $regionid = $region->id;
        $regionname = $region->name;
        $regionnbrOut = $region->nbrOut;
        $regionnbrServed = $region->nbrServed;
        $regionqry = "CALL outage_region_insert('".$outageid."', '".$regionid."','".$countyFIPSId."','".$stateFIPSId."','".$regionname."','".$regionnbrServed."','".$regionnbrOut."');" ;
        $rs = $db->query($regionqry); 
        $returnData = array(
        "status" => 'accepted');
      }
}
catch(Exception $e) {
    $returnData = array(
        "status" => 'error',
        "errors" => array(
            "error" => $e
        )
    );
  }
  

$xml_data = new SimpleXMLElement('<?xml version="1.0"?><data></data>');

// function call to convert array to xml
array_to_xml($returnData,$xml_data);

//saving generated xml file; 

$header = "Content-Type:text/xml";
print $xml_data->asXML();

?>