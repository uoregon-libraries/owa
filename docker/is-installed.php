<?php

require_once('owa_env.php');
require_once(OWA_DIR.'owa.php');

$owa = new owa;
if ($owa->isOwaInstalled()) {
  exit(0);
}
exit(1);
