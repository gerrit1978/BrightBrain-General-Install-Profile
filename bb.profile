<?php

function bb_install_tasks($install_state) {
  return array(
    'bb_install_import_locales' => array(
      'display_name' => 'Install additional languages',
      'display' => TRUE,
      'type' => 'batch',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ),
    'bb_set_default_language' => array(
      'display_name' => 'Set default language',
      'display' => TRUE,
      'type' => 'normal',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ),
  );
}

function bb_install_import_locales(&$install_state) {
  include_once DRUPAL_ROOT . '/includes/locale.inc';
  include_once DRUPAL_ROOT . '/includes/iso.inc';
  $batch = array();
  $predefined = _locale_get_predefined_list();
  
  // install both Dutch and French as languages
  foreach (array('nl', 'fr') as $install_locale) {
  
    $filename = DRUPAL_ROOT . '/profiles/bb/translations/' . $install_locale . '.po';
    
    $file = new StdClass();
    $file->uri = $filename;
    $file->filename = $install_locale . '.po';
  
    if (!isset($predefined[$install_locale])) {
      // Drupal does not know about this language, so we prefill its values with
      // our best guess. The user will be able to edit afterwards.
      locale_add_language($install_locale, $install_locale, $install_locale, LANGUAGE_LTR, '', '', TRUE, FALSE);
      _locale_import_po($file, $install_locale, LOCALE_IMPORT_OVERWRITE, 'default');
    }
    else {
      // A known predefined language, details will be filled in properly.
      locale_add_language($install_locale, NULL, NULL, NULL, '', '', TRUE, FALSE);
      _locale_import_po($file, $install_locale, LOCALE_IMPORT_OVERWRITE, 'default');
    }

    // Collect files to import for this language.
    $batch = array_merge($batch, locale_batch_by_language($install_locale, NULL));

  }
  if (!empty($batch)) {
      // Remember components we cover in this batch set.
      variable_set('bb_install_import_locales', $batch['#components']);
      return $batch;
  }
  
}

function bbn_set_default_language(&$install_state) {
  // set Dutch as default language
  $languages = language_list();
  variable_set('language_default', $languages['nl']);
}