<?php

/**
 * Model for livestock production records 
 *
 */

class LivestockProduction extends BaseEntity {

	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
				
		$this->setTableName('livestockproduction');
		
		$this->hasColumn('commodityid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('locationid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('collectedbyid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('prodtype', 'string', 50);
		$this->hasColumn('cost', 'decimal', 11, array('notnull' => true, 'notblank' => true, 'default' => '0'));
		$this->hasColumn('yield', 'decimal', 11, array('notnull' => true, 'notblank' => true, 'default' => '0'));
		$this->hasColumn('yieldtype', 'string', 50);
		$this->hasColumn('unitid', 'integer', null);
		$this->hasColumn('seedsource', 'string', 1000);
		$this->hasColumn('customprodtype', 'string', 255);
		$this->hasColumn('customunit', 'string', 255);
		$this->hasColumn('customyieldtype', 'string', 255); // customyield // customyieldtype
		$this->hasColumn('startdate','date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('enddate','date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('quarter', 'string', 15, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('datecollected','date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('collectedbyid', 'integer', null, array('notnull' => true, 'notblank' => true));
	} 
	
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		// define the date fields
		$this->addDateFields(array("startdate", "enddate", "datecollected"));
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"locationid.notblank" => $this->translate->_("livestock_locationid_error"),
       									"commodityid.notblank" => $this->translate->_("livestock_commodityid_error"),
       									"startdate.notblank" => $this->translate->_("livestock_startdate_error"),
       									"enddate.notblank" => $this->translate->_("livestock_enddate_error"),
       									"quarter.notblank" => $this->translate->_("livestock_quarter_error"),
       									"datecollected.notblank" => $this->translate->_("livestock_datecollected_error"),
       									"collectedbyid.notblank" => $this->translate->_("livestock_collectedbyid_error")
       	       						));
	}
	
	public function setUp() {
		parent::setUp(); 
		
		$this->hasOne('District as location',
						 array(
								'local' => 'locationid',
								'foreign' => 'id'
							)
					); 
		
		$this->hasOne('Commodity as commodity',
						 array(
								'local' => 'commodityid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('UserAccount as collectedby',
						 array(
								'local' => 'collectedbyid',
								'foreign' => 'id'
							)
					); 
	} 
	
	function processPost($formvalues){
		if(isArrayKeyAnEmptyString('cost', $formvalues)){
			unset($formvalues['cost']); 
		}
		if(isArrayKeyAnEmptyString('yield', $formvalues)){
			unset($formvalues['yield']); 
		}
		if(isArrayKeyAnEmptyString('unitid', $formvalues)){
			unset($formvalues['unitid']); 
		}
		if(isArrayKeyAnEmptyString('yieldtype', $formvalues)){
			unset($formvalues['yieldtype']); 
		}		
		if(isArrayKeyAnEmptyString('prodtype', $formvalues)){
			unset($formvalues['prodtype']); 
		}
		parent::processPost($formvalues);
	}	
	
	
}

?>