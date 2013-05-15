<?php

/**
 * Model for hand craft production records 
 *
 */

class HandCraftProduction extends BaseEntity {

	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
				
		$this->setTableName('handcraftproduction');
		
		$this->hasColumn('commodityid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('locationid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('retail', 'decimal', 11, array('default' => '0'));
		$this->hasColumn('wholesale', 'decimal', 11, array('default' => '0'));
		$this->hasColumn('unitid', 'integer', null);
		$this->hasColumn('comcustom', 'string', 255);
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
       									"locationid.notblank" => $this->translate->_("handcraft_locationid_error"),
       									"commodityid.notblank" => $this->translate->_("handcraft_commodityid_error"),
       									"startdate.notblank" => $this->translate->_("handcraft_startdate_error"),
       									"enddate.notblank" => $this->translate->_("handcraft_enddate_error"),
       									"quarter.notblank" => $this->translate->_("handcraft_quarter_error"),
       									"datecollected.notblank" => $this->translate->_("handcraft_datecollected_error"),
       									"collectedbyid.notblank" => $this->translate->_("handcraft_collectedbyid_error")
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
		
		if(isArrayKeyAnEmptyString('retail', $formvalues)){
			unset($formvalues['retail']); 
		}
		
		if(isArrayKeyAnEmptyString('wholesale', $formvalues)){
			unset($formvalues['wholesale']); 
		}
		if(isArrayKeyAnEmptyString('unitid', $formvalues)){
			unset($formvalues['unitid']); 
		}		
		parent::processPost($formvalues);
	}	
	
	
}

?>