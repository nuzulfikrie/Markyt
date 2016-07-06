<?php

/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
App::uses('Controller', 'Controller');

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package       app.Controller
 * @link http://book.cakephp.org/2.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller {

//    $this->viewPath;
    public $helpers = array(
        'Session');
    public $components = array(
        'Session',
        'Auth' => array(
            'loginRedirect' => array(
                'controller' => 'posts',
                'action' => 'publicIndex'),
            //'loginAction' => array('controller' => 'posts', 'action' => 'publicIndex'),
            'authError' => 'You are not authorized to access this location'));

    //aplana un array recursivamente
    public function flatten(array $array) {
        $return = array();
        array_walk_recursive($array, function($a) use (&$return) {
            $return[] = $a;
        });
        return $return;
    }

    /**
     * randomAlphaNum method
     * @param int $length
     * @return String
     */
    function randomAlphaNum($length = null) {
        if ($length == null)
            $length = rand(8, 15);
        $a_z = "!$&/()=?:;-*+";
        $int = rand(0, 12);
        $unique_key = substr(md5(rand(0, 1000000)), 0, $length) . $a_z[$int] . substr(md5(rand(0, 1000000)), 0, rand(0, 3));
        return $unique_key;
    }

    /**
     * backGround method
     * @param Array $location
     * @return void
     */
    public function backGround($location = null) {
        $redirect = $this->Session->read('redirect');
        $scriptTimeLimit = Configure::read('scriptTimeLimit');
        set_time_limit($scriptTimeLimit);

        //cortamos la ejecucion parab el usuario pero el script sigue en ejecucion
        //de esta forma el usuario puedeseguir navegando
        //sino estamos en la vista de un proyecto nos dirigimos a donde nos manden
        //en caso contrario volvemos a la vista
        //en caso de estar en la vista de un proyecto y querer eliminarlo nos vamos a donde nos manden
        if (!$this->request->is('ajax')) {
            if (isset($redirect) && is_array($redirect)) {
                if ($redirect['action'] == 'view' && $redirect['controller'] != 'projects') {
                    $redirect['action'] = 'index';
                    unset($redirect[0]);
                }
                header("Location: " . Router::url(($redirect)), true);
            } else if (isset($location)) {
                header("Location: " . $location);
            }
        }
        //Erase the output buffer
        ob_end_clean();
        //Tell the browser that the connection's closed
        header("Connection: close");
        //Ignore the user's abort (which we caused with the redirect).
        ignore_user_abort(true);
        //Start output buffering again
        ob_start();
        //Tell the browser we're serious... there's really
        //nothing else to receive from this page.
        header("Content-Length: 0");
        //Send the output buffer and turn output buffering off.
        ob_end_flush();
        //Yes... flush again.
        flush();
        //Close the session.
        session_write_close();
    }

    public function correctResponseJson($response) {
        $this->autoRender = false;
        if (isset($response)) {
            if (is_array($response)) {
                $response = json_encode($response);
            }

            $this->response->body($response);
        } else {
            $this->response->body('');
        }
        $this->response->type('json');
        return $this->response;
    }

    public function exportTsvDocument($lines = array(), $name = "export.tsv") {

        $response = "";
        foreach ($lines as $line) {
            $response.=$line . "\n";
        }

        $mimeExtension = 'text/tab-separated-values';
        $this->response->type($mimeExtension);
        $this->response->body($response);
        $this->response->download($name);
        $this->autoRender = false;
        return $this->response;
    }

    public function sendMailWithAttachment($template = null, $to_email = null, $subject = null, $contents = array(), $attachments = array()) {

        App::uses('CakeEmail', 'Network/Email');

        $emailProfile = Configure::read('emailProfile');
        $from_email = 'markyt.noreplay@gmail.com';
        $email = new CakeEmail($emailProfile);
        $result = $email
                ->to($to_email)
                ->template($template)
                ->emailFormat('html')
                ->from($from_email)
                ->subject($subject)
                ->attachments($attachments)
                ->viewVars($contents);
        if ($email->send()) {
            return true;
        }
        return false;
    }

    public function parseHtmlToGetAnnotations($content = null) {
//        $content = preg_replace('/\s+/', ' ', $content);
//        //las siguientes lineas son necesarias dado que cada navegador hace lo  que le da la gana con el DOM con respecto a la gramatica,
//        //no hay un estandar asi por ejemplo en crhome existe Style:valor y en Explorer Style :valor,etc
//        $content = str_replace(array(
//            "\n",
//            "\t",
//            "\r"
//                ), '', $content);
        //$textoForMatches = str_replace('> <', '><', $textoForMatches);
        $content = strip_tags($content, '<mark>');
        $content = utf8_decode(htmlspecialchars_decode($content));
        return trim($content);
    }

    public function filesize2bytes($str) {
        $bytes = 0;
        $bytes_array = array(
            'B' => 1,
            'KB' => 1024,
            'MB' => 1024 * 1024,
            'GB' => 1024 * 1024 * 1024,
            'TB' => 1024 * 1024 * 1024 * 1024,
            'PB' => 1024 * 1024 * 1024 * 1024 * 1024,
        );
        $bytes = floatval($str);

        if (preg_match('#([KMGTP]?B)$#si', $str, $matches) && !empty($bytes_array[$matches[1]])) {
            $bytes *= $bytes_array[$matches[1]];
        }

        $bytes = intval(round($bytes, 2));

        return $bytes;
    }

    public function bytesToHuman($size, $unit = "") {
        if ((!$unit && $size >= 1 << 30) || $unit == "TB")
            return number_format($size / (1 << 30), 2) . "TB";
        if ((!$unit && $size >= 1 << 20) || $unit == "GB")
            return number_format($size / (1 << 20), 2) . "GB";
        if ((!$unit && $size >= 1 << 10) || $unit == "MB")
            return number_format($size / (1 << 10), 2) . "MB";
        return number_format($size) . " bytes";
    }

    public function correctTsvFormat($file, $columns) {
        $columns--;
        $lines = $this->getNumberOfLines($file->pwd());
        $tabs = $this->getNumberOfTabs($file->pwd());
        debug($lines);
        debug(($lines * $columns));
        debug(($tabs));
        debug(($lines * $columns) == $tabs);
        throw new Exception;

        return ($lines * $columns) == $tabs;
    }

    public function incorrecLineTsvFormat($file) {

        $content = $file->read();
        $file->close();

        $lines = explode("\n", $content);

        $incorrectFormat = empty($lines);
        $count = -1;
        $size = count($lines);

        for ($index = 0; $index < $size; $index++) {
            if (strlen(trim($lines[$index])) > 0) {
                if (!$incorrectFormat) {
                    $columns = explode("\t", $lines[$index]);
                    for ($i = 0; $i < count($columns); $i++) {
                        if (strlen(trim($columns[$i])) == 0) {
                            $incorrectFormat = true;
                        }
                    }
                    $incorrectFormat = $incorrectFormat || sizeof($columns) != 5;
                    $count++;
                } else {
                    break;
                }
            }
        }

        return $count+=2;
    }

    private function getNumberOfLines($file) {
        $f = fopen($file, 'rb');
        $lines = 0;
        while (!feof($f)) {
            $line = fread($f, 8192);
            $lines += substr_count($line, "\n");
        }
        if (substr($line, -1) == "\n" && substr_count($line, "\n") > 1) {
            $lines--;
        }
        fclose($f);
        return $lines;
    }

    private function getNumberOfTabs($file) {
        $f = fopen($file, 'rb');
        $lines = 0;
        while (!feof($f)) {
            $lines += substr_count(fread($f, 8192), "\t");
        }
        fclose($f);
        return $lines;
    }

    public function killJob($id) {
        $this->loadModel('Job');
        $this->loadModel('UsersRound');
        $this->Job->id = $id;
        $job = $this->Job->read();
        $PID = $job["Job"]['PID'];
        $userIdJob = $job["Job"]['user_id'];
        $round_id = $job["Job"]['round_id'];
        //mirar si el proceso existe
        $success = false;
        $group_id = $this->Session->read('group_id');
        $user_id = $this->Session->read('user_id');

        if (isset($PID) && $PID != '' && file_exists("/proc/$PID")) {
            $success = posix_kill($PID, 9);
            sleep(1);
            $success = !file_exists("/proc/$PID");
        } else {
            $success = true;
        }

        if ($success) {
            $usersRound = $this->UsersRound->find('first', array(
                'recursive' => -1,
                'fields' => "id",
                'conditions' => array("user_id" => $userIdJob, "round_id" => $round_id)
            ));
            if (!empty($usersRound)) {
                $this->UsersRound->id = $usersRound["UsersRound"]["id"];
                $this->UsersRound->saveField('state', 0);
            }
            $this->Job->saveField('percentage', 100);
            $this->Job->saveField('status', "Canceled by user");
        }
//        if ($group_id == 1) {
//            $cascade = Configure::read("deleteCascade");
//            if ($this->Job->delete($this->Job->id, $cascade)) {
//                return $this->correctResponseJson(json_encode(array(
//                            'success' => true)));
//            } else {
//                return $this->correctResponseJson(json_encode(array(
//                            'success' => false,
//                            'message' => "The task could not be performed successfully"
//                )));
//            }
//        } else {
        return $this->correctResponseJson(json_encode(array(
                    'success' => $success)));
//        }
    }

    public function sendJob($id, $programName, $arguments, $returnJson = true) {
        $this->loadModel('Job');
        $runJava = Configure::read('runJava');
        $javaJarPath = Configure::read('javaJarPath');
        $javaProgram = "MARKYT_Scripts.jar";
        $program = $javaJarPath . DS . $javaProgram;
        $javaLog = $javaJarPath . DS . "java.log";
        $date = date('Y-m-d H:i:s');
        exec("echo \"$date:$runJava $program $arguments\" >> $javaLog 2>&1 &");
        $PID = exec("$runJava $program $arguments > /dev/null 2>&1 & echo $!;");
//                          $PID = exec("sleep 60 > /dev/null 2>&1 & echo $!;",$output);
        $this->Job->id = $id;
        $this->Job->set('PID', $PID);
        $this->Job->save(array('PID' => $PID, 'program' => $programName));
        if ($returnJson) {
            return $this->correctResponseJson(json_encode(array(
                        'success' => true,
                        'PID' => $this->Job->id)));
        }
    }

    public function beforeFilter() {
        $theme = Configure::read('Theme');
        $this->theme = $theme;

        /* $this->Auth->allow(array('forward', 'processUrl')); */
        $this->Auth->allow(array(
            'controller' => 'pages',
            'action' => 'display',
            'markyInformation'));
        $this->Auth->allow('postsSearch', 'publicIndex', 'recoverAccount');
        $this->Auth->allow('login', 'register', 'Logout');
        //cambiar aqui a que paginas se puede  ir sin registrarse
        $group = $this->Session->read('group_id');
        $controller = $this->request->params['controller'];
        //en minuculas dado que en mayusculas daba algunos errores
        $action = $this->request->params['action'];

        //dado a la dificultad de cakephp y sus permisos para acceder a las paginas
        //se ha optado por hacer nuestra propia forma de permiso a la hora de acceder a las paginas
        $controller = strtolower($controller);

        $deniedMessagge = 'You not authorized to enter this area, your action has been reported';
        $deniedRedirect = array(
            'controller' => 'rounds',
            'action' => 'index');
        //en minuculas dado que en mayusculas daba algunos errores
        if ($group == 99) {
            $this->Session->destroy();
        }
        if (isset($group) && $group != 1) {
            switch ($controller) {
                case 'pages' :
                    break;
                case 'videos' :
                    break;
//                case 'annotations' :
//                    break;
                case 'annotations' :
                    switch ($action) {
                        case 'redirectToAnnotatedDocument' :
                            break;
                    }
                    break;
                case 'annotationsquestions' :
                    break;
                case 'annotations_questions' :
                    break;
                case 'annotationsinterrelations' :
                    break;
                case 'annotations_inter_relations' :
                    break;
                case 'rounds' :
                    switch ($action) {
                        case 'user_view' :
                        case 'userView' :
                            break;
                        case 'index' :
                            break;
                        case 'search' :
                            break;
                        case 'getTypes' :
                            break;
                        case 'automaticAnnotation' :
                            break;
                        default :
                            $this->Session->setFlash($deniedMessagge);
                            $this->redirect($deniedRedirect);
                            break;
                    }
                    break;
                case 'users' :
                    switch ($action) {
                        case 'view' :
                            break;
                        case 'edit' :
                            break;
                        case 'login' :
                            break;
                        case 'logout' :
                            break;
                        case 'renewSession' :
                            break;
                        default :
                            $this->Session->setFlash($deniedMessagge);
                            $this->redirect($deniedRedirect);
                            break;
                    }
                    break;
                case 'annotateddocuments':
                case 'annotated_documents':
                case 'users_rounds' :
                case 'usersrounds' :
//                    switch ($action) {
//                        case 'view' :
//                            break;
//                        case 'start' :
//                            break;
//                        case 'start2' :
//                            break;
//                        case 'save' :
//                            break;
//                        case 'index' :
//                            break;
//                        default :
//                            $this->Session->setFlash($deniedMessagge);
//                            $this->redirect($deniedRedirect);
//                            break;
//                    }
                    break;
                case 'projectresources' :
                    switch ($action) {
                        case 'downloadAll' :
                            break;
                    }
                    break;
                case 'documentsassessments' :
                    switch ($action) {
                        case 'view' :
                            break;
                        case 'save' :
                            break;
                    }
                    break;
                case 'projects' :
                    switch ($action) {
                        case 'index' :
                            break;
                        case 'search' :
                            break;
                        case 'userView' :
                            break;
                        case 'statisticsForUser' :
                            break;
                        default :
                            $this->Session->setFlash($deniedMessagge);
                            $this->redirect($deniedRedirect);
                            break;
                    }
                    break;
                default :
                    //print_r($controller.' '.$action);
                    $this->Session->setFlash($deniedMessagge);
                    $this->redirect($deniedRedirect);
                    break;
            }
        } elseif (isset($group) && $group == 1) {
            $action = $this->request->params['action'];
            if ($action == 'view' && $controller != "usersrounds") {
                $redirect = array(
                    'controller' => $controller,
                    'action' => $action);
                if (!empty($this->request->params['pass'][0])) {
                    //print_r($this->request->params);
                    $redirect = array(
                        'controller' => $controller,
                        'action' => $action,
                        $this->request->params['pass'][0]);
                }
                $this->Session->write('redirect', $redirect);
            }
            if ($action == 'index') {
                //print_r($this->request->params);
                $redirect = array(
                    'action' => 'index');
                $this->Session->write('redirect', $redirect);
                $this->Session->write('comesFrom', $redirect);
            }
        }
    }

}
