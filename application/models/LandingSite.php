<?php

/**
 * Model for landing site records 
 *
 */

class LandingSite extends BaseEntity {

	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
				
		$this->setTableName('landingsite');
		$this->hasColumn('name', 'string', 50, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('description', 'string', 500);
		$this->hasColumn('waterbodyid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('districtid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('subcountyid','integer', null);
		$this->hasColumn('parishid','integer', null);
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
       									"name.notblank" => $this->translate->_("landingsite_name_error"),
       									"waterbodyid.notblank" => $this->translate->_("landingsite_waterbodyid_error"),
       									"districtid.notblank" => $this->translate->_("landingsite_districtid_error")
       	       						));
	}
	
	public function setUp() {
		parent::setUp(); 
		
		$this->hasOne('District as district',
						 array(
								'local' => 'districtid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('County as subcounty',
						 array(
								'local' => 'subcountyid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('Parish as parish',
						 array(
								'local' => 'parishid',
								'foreign' => 'id'
							)
					); 
							
		$this->hasOne('WaterBody as waterbody',
						 array(
								'local' => 'waterbodyid',
								'foreign' => 'id'
							)
					); 
	} 
	
	function processPost($formvalues){
		if(isArrayKeyAnEmptyString('subcountyid', $formvalues)){
			unset($formvalues['subcountyid']); 
		}
		
		if(isArrayKeyAnEmptyString('parishid', $formvalues)){
			unset($formvalues['parishid']); 
		}
		parent::processPost($formvalues);
	}

	
}

?>