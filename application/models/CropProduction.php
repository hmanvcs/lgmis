<?php

/**
 * Model for crop production records 
 *
 */

class CropProduction extends BaseEntity {

	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
				
		$this->setTableName('cropproduction');
		$this->hasColumn('locationid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('commodityid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('prodtype', 'string', 50);
		$this->hasColumn('cost', 'decimal', 11, array('notnull' => true, 'notblank' => true, 'default' => '0'));
		$this->hasColumn('yield', 'decimal', 11, array('notnull' => true, 'notblank' => true, 'default' => '0'));
		$this->hasColumn('yieldtype', 'string', 50);
		$this->hasColumn('unitid', 'integer', null);
		$this->hasColumn('costtype', 'string', 50);
		$this->hasColumn('seedsource', 'string', 1000);
		$this->hasColumn('comcustom', 'string', 255);
		$this->hasColumn('comtypecustom', 'string', 50);
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
       									"locationid.notblank" => $this->translate->_("cropsector_locationid_error"),
       									"commodityid.notblank" => $this->translate->_("cropsector_commodityid_error"),
       									"cost.notblank" => $this->translate->_("cropsector_cost_error"),
       									"yield.notblank" => $this->translate->_("cropsector_yield_error"),
       									"startdate.notblank" => $this->translate->_("cropsector_startdate_error"),
       									"enddate.notblank" => $this->translate->_("cropsector_enddate_error"),
       									"quarter.notblank" => $this->translate->_("cropsector_quarter_error"),
       									"datecollected.notblank" => $this->translate->_("cropsector_datecollected_error"),
       									"collectedbyid.notblank" => $this->translate->_("cropsector_collectedbyid_error")
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
		$this->hasOne('CommodityUnit as unit',
						 array(
								'local' => 'unitid',
								'foreign' => 'id'
							)
					); 
	} 
	
	function processPost($formvalues){
		if(isArrayKeyAnEmptyString('unitid', $formvalues)){
			unset($formvalues['unitid']); 
		}
		if(isArrayKeyAnEmptyString('cost', $formvalues)){
			$formvalues['cost'] = 0; 
		}
		if(isArrayKeyAnEmptyString('yield', $formvalues)){
			$formvalues['yield'] = 0; 
		}
		parent::processPost($formvalues);
	}	
}
?>