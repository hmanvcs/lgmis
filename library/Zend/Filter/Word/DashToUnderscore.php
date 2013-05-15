<?php
/**
 * Zend Framework
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://framework.zend.com/license/new-bsd
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@zend.com so we can send you a copy immediately.
 *
 * @category   Zend
 * @package    Zend_Filter
 * @copyright  Copyright (c) 2005-2011 Zend Technologies USA Inc. (http://www.zend.com)
 * @license    http://framework.zend.com/license/new-bsd     New BSD License
 * @version    $Id: DashToUnderscore.php,v 1.2 2011/10/06 12:01:23 smusoke Exp $
 */

/**
 * @see Zend_Filter_PregReplace
 */
require_once 'Zend/Filter/Word/SeparatorToSeparator.php';

/**
 * @category   Zend
 * @package    Zend_Filter
 * @copyright  Copyright (c) 2005-2011 Zend Technologies USA Inc. (http://www.zend.com)
 * @license    http://framework.zend.com/license/new-bsd     New BSD License
 */
class Zend_Filter_Word_DashToUnderscore extends Zend_Filter_Word_SeparatorToSeparator
{
    /**
     * Constructor
     *
     * @param  string $separator Space by default
     * @return void
     */
    public function __construct()
    {
        parent::__construct('-', '_');
    }
}