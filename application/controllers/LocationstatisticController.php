<?php

class LocationstatisticController extends SecureController {

	function getResourceForACL() {
		return "Location Statistic";
	}
	
	public function getActionforACL() {
		$action = strtolower($this->getRequest()->getActionName()); 
		
		if ($action == 'multiple' || $action == 'processmultiple') {
			return ACTION_CREATE; 
		}
		return parent::getActionforACL(); 
	}
			
	public function multipleAction(){
		
	}
	public function processmultipleAction(){
		
	 	$this->_helper->layout->disableLayout();
	    $session = SessionWrapper::getInstance(); 
	    $this->_translate = Zend_Registry::get("translate"); 
	    
	    $formvalues = $this->_getAllParams();
	   	// debugMessage($formvalues);
	   	
	    // add the parameters for updating the visit
		$this->_setParam('entityname', 'LocationStatistic'); 
		$this->_setParam('action', ACTION_CREATE);
		$submission_data = array();
		
		for($i=1; $i<=$formvalues['counter']; $i++){
			if(!isArrayKeyAnEmptyString('statisticid_'.$i, $formvalues) || !isArrayKeyAnEmptyString('customstat_'.$i, $formvalues)){
				
				$submission_data[$i]['startdate'] = changeDateFromPageToMySQLFormat($formvalues['startdate']);
				$submission_data[$i]['enddate'] = changeDateFromPageToMySQLFormat($formvalues['enddate']);
				$submission_data[$i]['locationid'] = $formvalues['locationid'];
				// check if using custom statistic
				if(!isArrayKeyAnEmptyString('customstattrigger_'.$i, $formvalues)){
					if($formvalues['customstattrigger_'.$i] == 1){
						$submission_data[$i]['statisticid'] = NULL;
						$submission_data[$i]['customstat'] = $formvalues['customstat_'.$i];
					}
				} else {
					$submission_data[$i]['statisticid'] = $formvalues['statisticid_'.$i];
					$submission_data[$i]['customstat'] = "";
				}
				// check if using custom unit
				if(!isArrayKeyAnEmptyString('customunittrigger_'.$i, $formvalues)){
					if($formvalues['customunittrigger_'.$i] == 1){
						$submission_data[$i]['unitid'] = NULL;
						$submission_data[$i]['customunit'] = $formvalues['customunit_'.$i];
					}
				} else {
					$submission_data[$i]['unitid'] = $formvalues['unit_'.$i];
					$submission_data[$i]['customunit'] = "";
				}
				
				$submission_data[$i]['value'] = $formvalues['value_'.$i];
				//$submission_data[$i]['createdby'] = $session->getVar('userid');
				$submission_data[$i]['createdby'] = $session->getVar('userid');
				if(!isArrayKeyAnEmptyString('id_'.$i, $formvalues)){
					$submission_data[$i]['id'] = $formvalues['id_'.$i];
				}
			} else {
				unset($formvalues['statisticid_'.$i]); unset($formvalues['customstat_'.$i]);
				unset($formvalues['unit_'.$i]); unset($formvalues['customunit_'.$i]);
				unset($formvalues['startdate_'.$i]);
				unset($formvalues['enddate_'.$i]);
				unset($formvalues['customunit_'.$i]);
				unset($formvalues['line_'.$i]);
				unset($formvalues['value_'.$i]);
			}
		}
		// debugMessage($formvalues);
		// debugMessage($submission_data);
		// exit();
		// collection to be used to save submissions
		$locationstatistic_collection = new Doctrine_Collection("LocationStatistic");
		// process each submission it and add to collection
		
		foreach ($submission_data as $thedata){
			$locationstatistic = new LocationStatistic();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$locationstatistic->processPost($thedata);
				// debugMessage($locationstatistic->getErrorStackAsString());
				if($locationstatistic->isValid()) {
					$locationstatistic_collection->add($locationstatistic);
				}
			} else {
				$locationstatistic->populate($thedata['id']);
				$locationstatistic->synchronizeWithArray($thedata, true);
				$locationstatistic_collection->add($locationstatistic);
			}
		}
		
		try {
			if($locationstatistic_collection->count() > 0){
				// save the collection of statistics
				$locationstatistic_collection->save(); 
			}
			// redirect to success page
			//debugMessage($locationstatistic_collection->toArray());
			//exit();
			$this->_redirect($this->view->baseUrl('locationstatistic/list'));
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			$this->_redirect($this->view->baseUrl('locationstatistic/multiple'));
		}
		return false;
	}
}

