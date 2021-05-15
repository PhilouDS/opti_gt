//--- LOADING DICTIONARY
set DIC_print_loading_text to "Chargement du dictionnaire : ".
set DIC_change_language_button_name to "Changer la langue".

//--- UNITS
set DIC_angle_unit to "°".
set DIC_velocity_unit to " m/s".
set DIC_length_unit to " m".
set DIC_hour_unit to "h".
set DIC_minute_unit to "min".
set DIC_second_unit to "s".

//--- FAIRING
set DIC_fairing_TAG to "coiffe".
set DIC_fairing_EVENT to "déployer".

//--- ANTENNAE
set DIC_antenna_EVENT to "déployer antenne".

//--- FLIGHT POPUP : GT only or GT + circularization
set DIC_normal_flight_suggested_amp_print_title     to "   Amp suggérée : ".
set DIC_normal_flight_selected_amp_print_title      to "    Amp choisie : ".
set DIC_normal_flight_suggested_vPitch_print_title  to "vPitch calculée : ".
set DIC_normal_flight_selected_vPitch_print_title   to " vPitch choisie : ".
set DIC_normal_flight_target_altitude_print_title   to "Altitude fin GT : ".

//--- WARNING PAGE
set DIC_warning_page_version to "OPTI GT, un script d'optimisation du GT, version ".
set DIC_warning_page_title to "<b>À LIRE ATTENTIVEMENT UNE BONNE FOIS POUR TOUTE</b>".
set DIC_warning_page_thanks to "Merci beaucoup d'utiliser notre script. On espère que les résultats seront à la hauteur de vos exigences. Afin que tout se passe convenablement, merci de prêter attention aux points suivants :".
set DIC_warning_page_utils to "1. L'utilisation du mod kOS.utils écrit par tony48 est obligatoire. Vérifiez que vous l'avez bien installé dans votre dossier GameData. <https://github.com/tony48/kOS.Utils>".
set DIC_warning_page_tag to "2. Un des composants du vaisseau doit obligatoirement comporter le tag kOS 'coiffe'. Il doit s'agir de votre coiffe si vous en avez une ou bien, si vous n'avez pas de coiffe, il s'agit du composant exposé installé le plus haut dans votre fusée. Si ce n'est pas déjà fait, vous pouvez le faire maintenant : faites un clic droit sur votre coiffe (ou sur un autre composant) et sélectionnez 'change name tag' puis écrivez 'coiffe'. Il est préférable de faire ce changement dans le BAV et de sauvegarder le vaisseau. Cette action est une nécessité à la fois pour déployer la coiffe automatiquement mais aussi pour réagir face à une surchauffe excessive (voir point ci-dessous)".
set DIC_warning_page_overheat to "3. Un GT optimal est un GT très tendu pendant lequel votre vaisseau passe beaucoup de temps proche de l'horizontale et donc beaucoup de temps dans l'atmosphère à une vitesse très élevée. Pour cela, il va vite faire très chaud et certains composants risquent de surchauffer. Attention à ne pas exposer trop de composants.".
set DIC_warning_page_execute_button to "Exécuter script".
set DIC_warning_page_quit_button to "Quitter script".

//--- PARAMETER WINDOW
set DIC_parameter_window_print_TWR to "RPP au décollage : ".
set DIC_parameter_window_title to "Réalisation d'un Gravity Turn automatisé :".
set DIC_parameter_window_auto_mode_button_name to "Valeurs présélectionnées".
set DIC_parameter_window_auto_mode_presentation to "Dans ce mode, l'amplitude et la vitesse d'initialisation du virage gravitationnel (Gravity Turn) sont automatiquement déterminées par nos propres équations. Vous avez cependant la possibilité de faire varier les paramètres (attention, la vitesse doit toujours être positive ou nulle). Le moteur principal est coupé lorsque l'apogée dépasse 100 km.".
set DIC_parameter_window_manual_mode_button_name to "Valeurs personnalisées".
set DIC_parameter_window_manual_mode_presentation to "Dans ce mode, vous pouvez tester n'importe quelles valeurs d'amplitude et de vitesse pour initialiser le virage gravitationnel (Gravity Turn). Vous pouvez choisir l'apogée à laquelle le moteur est coupé. L'amplitude doit être comprise entre 0 et 90°. Ne pas indiquer le symbole °. La vitesse doit être supérieure ou égale à 0. L'apogée est ramenée à un minimum de 75_000 m si nécessaire. Pour des raisons de sécurité, nous suggérons toutefois de choisir une apogée de 100_000 m.".
set DIC_parameter_window_gtopti_mode_button_name to "Recherche d'un GT optimal".
set DIC_parameter_window_gtopti_mode_presentation to "Dans ce mode, kOS va effectuer une série de lancements en prenant comme point de départ l'amplitude et la vitesse calculée par nos propres équations. Il va ensuite optimiser au mieux le virage gravitationnel (Gravity Turn) en fonction de la conception de votre vaisseau et des lancements précédents. Vous aurez le bilan de ses tests à la fin de la procédure.".

set DIC_parameter_window_already_tested_text to "<b>Une recherche d'optimisation a déjà été effectuée avec un vaisseau du même nom.</b>".
set DIC_parameter_window_already_tested_date to "Le dernier test a eu lieu le ".
set DIC_parameter_window_already_tested_hour to " à ".
set DIC_parameter_window_already_tested_amp_text to "Valeurs retenues : Amp = ".
set DIC_parameter_window_already_tested_vPitch_text to "vPitch = : ".

//--- parameter window ~ auto box
set DIC_parameter_window_auto_mode_box_suggested_amp to "AMP suggérée : ".
set DIC_parameter_window_auto_mode_box_amp_choice_title to "Choisir une amplitude :".
set DIC_parameter_window_auto_mode_box_amp_choice_button_suggested to "Amplitude suggérée".
set DIC_parameter_window_auto_mode_box_amp_choice_button_85 to "Choisir 85°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_80 to "Choisir 80°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_75 to "Choisir 75°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_70 to "Choisir 70°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_65 to "Choisir 65°".
set DIC_parameter_window_auto_mode_box_suggested_vPitch to "vPitch calculée : ".
set DIC_parameter_window_auto_mode_box_vPitch_choice_title to "Augmenter vitesse calculée ?".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_15 to "Choix sérénité : +15 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_8 to "Choix standard : +8 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_4 to "Choix risqué : +4 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_0 to "Choix fou : +0 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_0_forced to "Utiliser vPitch = 0 m/s".
set DIC_parameter_window_auto_mode_box_GTonly_button_name to "GT seulement".
set DIC_parameter_window_auto_mode_box_GTCirc_button_name to "GT + Circularisation".

//--- parameter window ~ manual box
set DIC_parameter_window_manual_mode_box_title to "<b>Valeurs souhaitées pour initialiser le GT :</b>".
set DIC_parameter_window_manual_mode_box_amp_title to "Amplitude (entre 0 et 90) :".
set DIC_parameter_window_manual_mode_box_amp_tooltip to "Angle au-dessus de l'horizon.".
set DIC_parameter_window_manual_mode_box_vPitch_title to "vPitch (sup. ou égale à 0) :".
set DIC_parameter_window_manual_mode_box_vPitch_tooltip to "vPitch en m/s.".
set DIC_parameter_window_manual_mode_box_apoapsis_title to "Apogée (min 75_000) :".
set DIC_parameter_window_manual_mode_box_apoapsis_tooltip to "Altitude en m (100_000 conseillée).".
set DIC_parameter_window_manual_mode_box_GTonly_button_name to "GT seulement".
set DIC_parameter_window_manual_mode_box_GTCirc_button_name to "GT + Circularisation".

//--- parameter window ~ gtopti box
set DIC_parameter_window_gtopti_mode_box_title to "<b>Recherche d'un Gravity Turn optimal</b>".
set DIC_parameter_window_gtopti_mode_box_warning to "<b>Attention : La recherche d'un GT optimal va nécessiter plusieurs vols et peut prendre plusieurs dizaines de minutes. Vous n'avez rien à faire durant toute la durée du test. Restez tranquillement assis sans toucher à rien ou... Profitez-en pour manger quelques snacks !</b>".
set DIC_parameter_window_gtopti_mode_box_button_name to "<b>Lancer la recherche d'un Gravity Turn optimisé !</b>".

//--- parameter window ~ cancel button
set DIC_parameter_window_cancel_button_name to "ANNULER LE SCRIPT ET REVENIR AU VAISSEAU".

//--- FLIGHT POPUP (gt opti)
set DIC_flight_popup_title to "OPTIMISATION DU GRAVITY TURN EN COURS".
set DIC_flight_popup_flight_number_text to "VOL N°".
set DIC_flight_popup_test_vPitch_text to "vPitch : ".
set DIC_flight_popup_amp_text to "Amplitude : ".
set DIC_flight_popup_relaunch_text to "Relance du vol dans :".

//--- ORBIT WINDOW
set DIC_orbit_window_title to "<b>~ CARACTÉRISTIQUES DE L'ORBITE ~</b>".
set DIC_orbit_window_amp_title to "Amp utilisée : ".
set DIC_orbit_window_vPitch_title to "vPitch utilisée : ".
set DIC_orbit_window_APO_name to "Apogée : ".
set DIC_orbit_window_PE_name to "Périgée : ".
set DIC_orbit_window_ARG_PE_name to "Argument du Périgée : ".
set DIC_orbit_window_ECC_name to "Excentricité : ".
set DIC_orbit_window_PERIOD_name to "Période orbitale : ".
set DIC_orbit_window_INC_name to "Inclinaison : ".
set DIC_orbit_window_LAN_name to "Longitude du noeud ascendant : ".
set DIC_orbit_window_button_continue_name to "Continuer Vol".
set DIC_orbit_window_button_revert_launch_name to "Relancer Vol*".
set DIC_orbit_window_revert_launch_info to "*Relancer Vol permet de tester de nouvelles valeurs pour Amp et vPitch.".

//--- SPACE WINDOW
set DIC_space_window_title to "<b>~ VOUS AVEZ ATTEINT L'ESPACE ~</b>".
set DIC_space_window_amp_title to "Amp utilisée : ".
set DIC_space_window_vPitch_title to "vPitch utilisée : ".
set DIC_space_window_button_continue_name to "Continuer Vol".
set DIC_space_window_button_revert_launch_name to "Relancer Vol*".
set DIC_space_window_revert_launch_info to "*Relancer Vol permet de tester de nouvelles valeurs pour Amp et vPitch.".

//--- RECAP FILE
set DIC_recap_file_first_line to "Date;Heure;Nom du vaisseau;Amp;vPitchOpti;Apogee;Nombre de vols;Duree du test;Commentaires".

//--- RUD FILE
set DIC_rud_file_title to "Arrêts d'urgence suite à une explosion".
set DIC_rud_file_first_line to "Date;Heure;Nom du vaisseau;Amp;vPitchOpti;Altitude;Vitesse;Temps mission".

//--- DATA FILE (temp file)
set DIC_data_file_first_line to "startTime;Amp;oldDelta;newDelta;newVpitch;minVpitch;maxVpitch;Apogee;Resultat;numVol;nouvelleAmp?".

//--- FLIGHT STATUS
set DIC_flight_status_success to "SUCCÈS".
set DIC_flight_status_failure to "ÉCHEC".
set DIC_flight_status_newLaunch_text to " - Nouveau lancement dans ".

//--- RECAP WINDOW
set DIC_recap_window_title to "<b>SIMULATION TERMINÉE</b>".
set DIC_recap_window_congrats_title to "Félicitations ! La recherche du Pitch Over optimal pour votre lanceur est terminée !".
set DIC_recap_window_limit to "La recherche d'optimisation arrive aux limites de notre script. Votre lanceur a un RPP très elevé et son ascension est très agressive. Vous pourriez envisager de limiter sa puissance.".
set DIC_recap_window_info_text to "<i>Voici quelques informations utiles à retrouver dans le fichier 'recap.csv' disponible dans le répertoire suivant : \Votre_Repertoire_KSP\Ships\Script\OptiGT. Ne supprimez pas ce fichier, il vous servira pour toutes vos simulations.</i>".
set DIC_recap_window_amp_title to "Amp retenue : ".
set DIC_recap_window_vPitch_title to "vPitch OPTI retenue : ".
set DIC_recap_window_number_flights_title to "Nombre de vols effectués : ".
set DIC_recap_window_simulation_time_title to "Durée totale de la simulation : ".
set DIC_recap_window_add_description_text to "Si vous le souhaitez, vous pouvez ajouter un court commentaire ci-dessous qui sera sauvegardée dans votre fichier 'recap.csv'.".
set DIC_recap_window_add_description_tooltip to "Commentaire court : attention, pas de saut de ligne automatique...".
set DIC_recap_window_final_decision_text to "Souhaitez-vous rejoindre le BAV ou bien recharger votre lanceur sur le pas de tir ?".
set DIC_recap_window_VAB_text to "BAV".
set DIC_recap_window_launchPad_text to "Pas de tir".
set DIC_recap_window_save_recap_button_text to "Sauvegarder les données de vols dans le dossier Script.".
set DIC_recap_window_save_recap_button_text_already_saved to "Données de vol sauvegardées dans Script/".

//--- RESET A SIMULATION WITH THE ACTUAL FLIGHT
set DIC_new_sim_window_info to "Il semblerait qu'une simulation soit en cours avec un vaisseau d'un autre nom. Pour une raison inconnue, la simulation suivante n'a pas abouti :".

set DIC_new_sim_window_info_craft_name to "Nom du vaisseau :".
set DIC_new_sim_window_info_date to "Date :".
set DIC_new_sim_window_info_time to "Heure :".
set DIC_new_sim_window_info_Amp to "Amp :".
set DIC_new_sim_window_info_vPitch to "vPitch :".

set DIC_new_sim_window_info_question to "Souhaitez-vous revenir au BAV pour recharger le précédent vaisseau et poursuivre la simulation ou bien souhaitez-vous lancer le script avec le vaisseau actuel (ce qui supprimera définitivement l'ancienne simulation) ?".

set DIC_new_sim_window_button_change_text to "Changer de vaisseau (BAV)".
set DIC_new_sim_window_button_keep_text to "Conserver ce vaisseau".

//--- RESET A SIMULATION WITH THE ACTUAL FLIGHT
set DIC_reset_sim_window_info to "Il semblerait qu'une simulation soit déjà en cours avec ce vaisseau. Pour une raison inconnue, la simulation n'a pas abouti. Voilà les dernières informations connues :".

set DIC_reset_sim_window_info_date to "Date :".
set DIC_reset_sim_window_info_time to "Heure :".
set DIC_reset_sim_window_info_Amp to "Amp :".
set DIC_reset_sim_window_info_vPitch to "vPitch :".

set DIC_reset_sim_window_info_question to "Souhaitez-vous poursuivre la simulation ou bien recharger le script (ce qui supprimera définitivement l'ancienne simulation) ?".

set DIC_reset_sim_window_button_continue_text to "Poursuivre simulation".
set DIC_reset_sim_window_button_new_text to "Nouvelle simulation".

//--- ABORT POPUP
set DIC_abort_popup_title to "<b>ANNULATION MANUELLE</b>".
set DIC_abort_popup_info to "Surchauffe inhabituelle ? Cliquez vite sur ce bouton avant que tout n'explose. VIIIIIITE !!".
set DIC_abort_popup_button_text to "ARRÊT D'URGENCE".

//--- warning high TWR window
set DIC_warningTWR_popup_title to "<b>RPP EXCESSIF</b>".
set DIC_warningTWR_popup_info_one to "Votre RPP excède notre modèle. Même avec une forte majoration, la vPitch calculée est négative et devra être ramenée à 0.".
set DIC_warningTWR_popup_info_two to "Un RPP aussi élevé au décollage n'est pas utile : nous vous conseillons d'avoir un RPP compris entre 1,3 et 2 sur le pas de tir.".
set DIC_warningTWR_popup_button_text to "COMPRIS".

//--- PRO POPUP
set DIC_pro_popup_title to "<b>JE SUIS UN PRO</b>".
set DIC_pro_popup_success_text to "Je suis capable de reconnaître que le vol en cours va aboutir. Il faut diminuer la vPitch.".
set DIC_pro_popup_success_button to "GT TROP TARD".
set DIC_pro_popup_failure_text to "Je suis capable de reconnaître que le vol en cours va échouer. Il faut augmenter la vPitch.".
set DIC_pro_popup_failure_button to "GT TROP TÔT".
set DIC_pro_popup_staging_text to "J'ai besoin de passer à l'étage suivant. Pourquoi ? Parce que c'est moi qui décide !".
set DIC_pro_popup_staging_button to "DÉCOUPLER MAINTENANT".