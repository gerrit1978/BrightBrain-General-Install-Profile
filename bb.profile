<?php

function bb_install_tasks($install_state) {
  return array(
    'bb_set_default_language' => array(
      'display_name' => 'Set default language',
      'display' => TRUE,
      'type' => 'normal',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ),
    'bb_add_homepage' => array(
      'display_name' => 'Create a homepage',
      'display' => TRUE,
      'type' => 'normal',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ),
  );
}

function bb_set_default_language(&$install_state) {
  // set Dutch as default language
  $languages = language_list();
  variable_set('language_default', $languages['nl']);
}


function bb_add_homepage(&$install_state) {
  $node = new StdClass();
  $node->uid = 1;
  node_save($node);
  
  variable_set('site_frontpage', 'node/1');
}