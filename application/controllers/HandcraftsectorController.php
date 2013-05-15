<?php

class HandcraftsectorController extends SecureController {	
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return "Handcraft Production"; 
	}
	public function handcraftsectorinfoAction(){
		
	}
	public function handcraftsectorinfolistAction(){
		$this->_translate = Zend_Registry::get("translate"); 
		
		$listcount = new LookupType();
    	$listcount->setName("LIST_ITEM_COUNT_OPTIONS");
    	$values = $listcount->getOptionValues(); 
    	asort($values, SORT_NUMERIC); 
    	$dropdown = new Zend_Form_Element_Select('itemcountperpage',
							array(
								'multiOptions' => $values, 
								'view' => new Zend_View(),
								'decorators' => array('ViewHelper')
							)
						);
		if (isEmptyString($this->getRequest()->itemcountperpage)) {
			$dropdown->setValue(10);
		} else {
			$dropdown->setValue($this->getRequest()->itemcountperpage);
		}  
	    $this->view->listcountdropdown = $this->_translate->translate("list_itemcount_dropdown").$dropdown->render();
	}
	public function handcraftsectorinfolistsearchAction(){
		$this->_helper->redirector->gotoSimple('handcraftsectorinfolist', $this->getRequest()->getControllerName(), 
    											$this->getRequest()->getModuleName(),
    											array_remove_empty(array_merge_maintain_keys($this->_getAllParams(), $this->getRequest()->getQuery())));
	}
	/* (non-PHPdoc)
	 * @see SecureController::getActionforACL()
	 */
	public function getActionforACL() {
		$action = strtolower($this->getRequest()->getActionName()); 
		
		if ($action == 'handcraftsectorinfo') {
			return ACTION_CREATE; 
		}
		if ($action == 'processhandcraftsectorinfo') {
			return ACTION_CREATE; 
		}
		if ($action == 'handcraftsectorinfolist' || $action == 'handcraftsectorinfolistsearch' ) {
			return ACTION_LIST; 
		}
		return parent::getActionforACL(); 
	}
	public function createAction(){
		$this->_helper->layout->disableLayout();
	    $session = SessionWrapper::getInstance(); 
	    $this->_translate = Zend_Registry::get("translate"); 
	   
	    $formvalues = $this->_getAllParams();
	    
	    //generate the start and end dates from the quarter
		if(!isArrayKeyAnEmptyString('quarter', $formvalues)){
			$quarter_dates = getDatesForQuarter($formvalues['quarter']); 
			//add the start and end date to formvalues data
			$formvalues = array_merge_maintain_keys($formvalues, $quarter_dates); 
		}
	    // debugMessage($formvalues); // exit();
	    
	    // add the parameters for updating the visit
		$this->_setParam('entityname', 'HandCraftInformation'); 
		$this->_setParam('action', ACTION_CREATE);
		$submission_data = array();
		$counter = $formvalues['counter'];
		for($i=0; $i <= $counter; $i++){
			if(!isArrayKeyAnEmptyString('commodityid_'.$i, $formvalues)){
				$submission_data[$i]['commodityid'] = $formvalues['commodityid_'.$i];
				$submission_data[$i]['retail'] = $formvalues['retail_'.$i];
				$submission_data[$i]['wholesale'] = $formvalues['wholesale_'.$i];
				
				$submission_data[$i]['locationid'] = $formvalues['locationid'];
				$submission_data[$i]['collectedbyid'] = $formvalues['collectedbyid'];
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['startdate'] = changeDateFromPageToMySQLFormat($formvalues['startdate']);
				$submission_data[$i]['enddate'] = changeDateFromPageToMySQLFormat($formvalues['enddate']);
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['quarter'] = str_replace(':', '.', $formvalues['quarter']);
				$submission_data[$i]['createdby'] = $session->getVar('userid');
				if(isNotAnEmptyString($formvalues['id_'.$i])){
					$submission_data[$i]['id'] = $formvalues['id_'.$i];
				}
			}
		}
		
		// collection to be used to save submissions
		$handcraftsector_collection = new Doctrine_Collection("HandCraftProduction");
		
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			$handcraftsector = new HandCraftProduction();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$handcraftsector->processPost($thedata);
				
				if($handcraftsector->isValid()) {
					$handcraftsector_collection->add($handcraftsector);
				}
			} else {
				$handcraftsector->populate($thedata['id']);
				$handcraftsector->synchronizeWithArray($thedata, true);
				$handcraftsector_collection->add($handcraftsector);
			}
		}
		
		try {
			// save the collection of handcraft sectors
			$handcraftsector_collection->save(); 
			
			// through commodity price category and add ti 
			foreach ($handcraftsector_collection as $sector) {
				$cpc = new CommodityPriceCategory();
				$cpc_obj = $cpc->getTheCommodityPriceCategory($sector->getCommodityID(), 9);
				// debugMessage($cpc_obj->toArray());
				if(!$cpc_obj){
					// category for commodity not found. save new
					$cpc->setCommodityID($sector->getCommodityID());
					$cpc->setPriceCategoryID(9);
					$cpc->save();
				}
			}
			// redirect to success page
			$this->_redirect($this->view->baseUrl('handcraftsector/list/quarter/'.$this->_getParam('quarter')));
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			
			$this->_redirect($this->view->baseUrl('handcraftsector/create/quarter/'.$this->_getParam('quarter')));
		}
	}
	
	/*
	 * Processing for handcraft information
	 */
	public function processhandcraftsectorinfoAction(){
		$this->_helper->layout->disableLayout();
	    $session = SessionWrapper::getInstance(); 
	    $this->_translate = Zend_Registry::get("translate"); 
	    $this->_setParam('entityname', 'HandCraftInformation'); 
		$this->_setParam('action', ACTION_CREATE);
		
	    $formvalues = $this->_getAllParams();
	    
	    //generate the start and end dates from the quarter
		if(!isArrayKeyAnEmptyString('quarter', $formvalues)){
			$quarter_dates = getDatesForQuarter($formvalues['quarter']); 
			//add the start and end date to formvalues data
			$formvalues = array_merge_maintain_keys($formvalues, $quarter_dates); 
		}
	    // debugMessage($formvalues); exit();
	    
	    // add the parameters for updating the crop sector infor
		$submission_data = array();
		$counter = $formvalues['counter'];
		for($i=0; $i<$counter; $i++){
			if(!isArrayKeyAnEmptyString('commodityid_'.$i, $formvalues)){
				$submission_data[$i]['commodityid'] = $formvalues['commodityid_'.$i];	
				$submission_data[$i]['materialsource'] = $formvalues['materialsource_'.$i];	
				$submission_data[$i]['materialtype'] = $formvalues['materialtype_'.$i];	
				$submission_data[$i]['market'] = $formvalues['market_'.$i];	
				$submission_data[$i]['creditsource'] = $formvalues['creditsource_'.$i];	
				
				$submission_data[$i]['locationid'] = $formvalues['locationid'];
				$submission_data[$i]['collectedbyid'] = $formvalues['collectedbyid'];
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['startdate'] = changeDateFromPageToMySQLFormat($formvalues['startdate']);
				$submission_data[$i]['enddate'] = changeDateFromPageToMySQLFormat($formvalues['enddate']);
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['quarter'] = str_replace(':', '.', $formvalues['quarter']);
				$submission_data[$i]['createdby'] = $session->getVar('userid');
				if(isNotAnEmptyString($formvalues['id_'.$i])){
					$submission_data[$i]['id'] = $formvalues['id_'.$i];
				}
			}
				
		}
		// collection to be used to save submissions
		$handcraftinfo_collection = new Doctrine_Collection("HandCraftInformation");
		
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			$handcraftinfo = new HandCraftInformation();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$handcraftinfo->processPost($thedata);
				
				if($handcraftinfo->isValid()) {
					$handcraftinfo_collection->add($handcraftinfo);
				}
			} else {
				$handcraftinfo->populate($thedata['id']);
				$handcraftinfo->synchronizeWithArray($thedata, true);
				$handcraftinfo_collection->add($handcraftinfo);
			}
		}
		
		try {
			// save the collection of handcraft sector information
			$handcraftinfo_collection->save(); 
			
			// through commodity price category and add ti 
			foreach ($handcraftinfo_collection as $sector) {
				$cpc = new CommodityPriceCategory();
				$cpc_obj = $cpc->getTheCommodityPriceCategory($sector->getCommodityID(), 9);
				// debugMessage($cpc_obj->toArray());
				if(!$cpc_obj){
					// category for commodity not found. save new
					$cpc->setCommodityID($sector->getCommodityID());
					$cpc->setPriceCategoryID(9);
					$cpc->save();
				}
			}
			// redirect to success page
			$this->_redirect($this->view->baseUrl('handcraftsector/handcraftsectorinfolist/quarter/'.$this->_getParam('quarter')));
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			$this->_redirect($this->view->baseUrl('handcraftsector/handcraftsectorinfo/quarter/'.$this->_getParam('quarter')));
		}
	}
}

