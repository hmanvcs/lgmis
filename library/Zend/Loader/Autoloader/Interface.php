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
 * @package    Zend_Loader
 * @subpackage Autoloader
 * @copyright  Copyright (c) 2005-2011 Zend Technologies USA Inc. (http://www.zend.com)
 * @version    $Id: Interface.php,v 1.2 2011/10/06 12:02:12 smusoke Exp $
 * @license    http://framework.zend.com/license/new-bsd     New BSD License
 */

/**
 * Autoloader interface
 *
 * @package    Zend_Loader
 * @subpackage Autoloader
 * @copyright  Copyright (c) 2005-2011 Zend Technologies USA Inc. (http://www.zend.com)
 * @license    http://framework.zend.com/license/new-bsd     New BSD License
 */
interface Zend_Loader_Autoloader_Interface
{
    /**
     * Autoload a class
     *
     * @abstract
     * @param   string $class
     * @return  mixed
     *          False [if unable to load $class]
     *          get_class($class) [if $class is successfully loaded]
     */
    public function autoload($class);
}
