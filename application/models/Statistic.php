<?php

/**
 * Model for statistics values 
 *
 */

class Statistic extends BaseEntity {
	
	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
		
		$this-> setTableName('statistic');
		$this->hasColumn('value', 'string', 500, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('unitid', 'integer', null); 
		$this->hasColumn('type', 'integer', null);
		$this->hasColumn('locationid', 'integer', null);
		$this->hasColumn('description', 'string', 255);
	}
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"value.notblank" => $this->translate->_("statistic_value_error")
       	       						));
	}
	
	public function setUp() {
		parent::setUp(); 
		
		// the location for which the details are being provided
		$this->hasOne('District as location',
						 array(
								'local' => 'locationid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('CommodityUnit as unit',
						 array(
								'local' => 'unitid',
								'foreign' => 'id'
							)
					); 
	}
 	# preprocess model data
	function processPost($formvalues){
		# force setting of default none string column values. enum, int and date 	
		if(isArrayKeyAnEmptyString('unitid', $formvalues)){
			unset($formvalues['type']); 
		}
		if(isArrayKeyAnEmptyString('type', $formvalues)){
			unset($formvalues['type']); 
		}
		if(isArrayKeyAnEmptyString('locationid', $formvalues)){
			unset($formvalues['locationid']); 
		}
		parent::processPost($formvalues);
	}	
}

?>