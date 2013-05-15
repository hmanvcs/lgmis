<?php

/**
 * Model for the units of measure for commodities 
 *
 */

class CommodityUnit extends BaseEntity {
	
	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
		
		$this->setTableName('commodityunit');
		
		$this->hasColumn('name', 'string', 15, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('description', 'string', 255);
		$this->hasColumn('type', 'integer', null);
		
		$this->unique(array("name")); 
	}
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"name.notblank" => $this->translate->_("global_name_error"),
       									"name.unique" => $this->translate->_("global_name_unique"),
       									"name.length" => $this->translate->_("global_name_length_error")							
       	       						));
	}
	/*
	 * Custom model processing
	 */
	function processPost($formvalues){
		// trim spaces from the name field
		if (!isArrayKeyAnEmptyString('name', $formvalues)) {
			$formvalues['name'] = trim($formvalues['name']);
		}
		if (isArrayKeyAnEmptyString('type', $formvalues)) {
			unset($formvalues['type']); 
		}
		// debugMessage($formvalues);
		parent::processPost($formvalues);
	}
	# determine the commodity unit type
	function getTypeLabel() {
		$unittype = '';
        switch($this->getType()){
        	case 2:
				$unittype = 'Statistic Measure';
				break;
			case 3:
				$unittype = 'Crop Input Measure';
				break;
			case 4:
				$unittype = 'Yield Measure';
				break;
			case 5:
				$unittype = 'Livestock Measure';
				break;
			default:
				$unittype = 'Standard Measure';
				break;
		}
		return $unittype;
	}
	# determine if is a standard unit
	function isStandard() {
		return $this->getType() == 1 ? true : false;  
	}
	# determine if is a statisctic unit
	function isStatistic() {
		return $this->getType() == 2 ? true : false;  
	}
	# determine if is a crop input unit
	function isCropInput() {
		return $this->getType() == 3 ? true : false;  
	}
	# determine if is a crop yield measure
	function isYieldMeasure() {
		return $this->getType() == 4 ? true : false;  
	}
	function isLiveStockMeasure() {
		return $this->getType() == 5 ? true : false;  
	}
	# determine if is a livestock unit 
	
	
}

?>