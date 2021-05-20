//--- LOADING DICTIONARY
set DIC_print_loading_text to "Loading dictionary : ".
set DIC_change_language_button_name to "Change the language".

//--- UNITS
set DIC_angle_unit to "°".
set DIC_velocity_unit to " m/s".
set DIC_length_unit to " m".
set DIC_hour_unit to "h".
set DIC_minute_unit to "min".
set DIC_second_unit to "s".

//--- FAIRING
set DIC_fairing_TAG to "fairing".
set DIC_fairing_EVENT to "deploy".

//--- ANTENNAE
set DIC_antenna_EVENT to "extend antenna".

//--- FLIGHT POPUP : GT only or GT + circularization
set DIC_normal_flight_suggested_amp_print_title     to "     Suggested Amp: ".
set DIC_normal_flight_selected_amp_print_title      to "        Chosen Amp: ".
set DIC_normal_flight_suggested_vPitch_print_title  to "   Computed vPitch: ".
set DIC_normal_flight_selected_vPitch_print_title   to "     Chosen vPitch: ".
set DIC_normal_flight_target_altitude_print_title   to "GT Ending Altitude: ".

//--- WARNING PAGE
set DIC_warning_page_version to "OPTI GT, a script to optimize a GT, version ".
set DIC_warning_page_title to "<b>TO READ CAREFULLY ONCE AND FOR ALL</b>".
set DIC_warning_page_thanks to "Thank you for using our script. We hope the results will meet all your expectations. To ensure that all will run smoothly, please read with attention the following points:".
set DIC_warning_page_utils to "1. The use of the mod kOS.utils by tony48 is mandatory. Please check it's correctly installed in your GameData folder. <https://github.com/tony48/kOS.Utils>".
set DIC_warning_page_tag to "2. One of your ship's parts must be tagged 'fairing'. It must be you fairing if yor ship has one or, if it doesn't, it should be the heighest exposed part of your ship. If it's not done yet, you can do it now : right clic on your fairing (or any other part) and select 'change name tag'. Then, just wirte 'fairing'. Yet, it's better to make that change in the VAB and save the ship. This action is an absolute need both to deploy the fairing and to react to overheating (see below).".
set DIC_warning_page_overheat to "3. An optimal GT is a very stretched GT, during which your craft spend a lot of time close to the horizon line and in the atmosphere with a very high speed. This means it's going to go very hot and some parts can explode of overheating. Be careful to not expose your parts to much.".
set DIC_warning_page_execute_button to "Execute script".
set DIC_warning_page_quit_button to "Quit script".

//--- PARAMETER WINDOW
set DIC_parameter_window_print_TWR to "TWR at the launchpad: ".
set DIC_parameter_window_title to "Realisation of an automated Gravity Turn:".
set DIC_parameter_window_auto_mode_button_name to "Preselected values".
set DIC_parameter_window_auto_mode_presentation to "In this mode, the amplitude and the pitch velocity that initialize the gravity turn are automatically computed with our own equations. Howerver, you have the possibility to apply changes to the parameter (be aware that the velocity must be positive). The main engine is cut when the apoapsis reaches 100 km.".
set DIC_parameter_window_manual_mode_button_name to "Personnal values".
set DIC_parameter_window_manual_mode_presentation to "In this mode, you can test any amplitude and pitch velocity you want to initialize the gravity turn. You can choose the apoapsis for which the main engine is cut. The amplitude is a value between 0 and 90°. Do not write the symbol °. The velocity must be equal to or greater than 0. The apoapsis is set to a minimum of 75_000 m if needed. For safety reasons, we suggest a minimum apoapsis of 100_000 m.".
set DIC_parameter_window_gtopti_mode_button_name to "Looking for the optimal GT".
set DIC_parameter_window_gtopti_mode_presentation to "In this mode, kOS will perform a series of launches starting with the initial amplitude and pitch velocity computed. It'll try to find the best gravity turn according to your craft's conception. A recap of this simulation will appear at the very end of the procedure.".

set DIC_parameter_window_already_tested_text to "<b>A research of optimization has already been done with a craft of the same name.</b>".
set DIC_parameter_window_already_tested_date to "The last test occured the ".
set DIC_parameter_window_already_tested_hour to " at ".
set DIC_parameter_window_already_tested_amp_text to "The values kept are: Amp = ".
set DIC_parameter_window_already_tested_vPitch_text to "vPitch = ".

//--- parameter window ~ auto box
set DIC_parameter_window_auto_mode_box_suggested_amp to "Suggested AMP: ".
set DIC_parameter_window_auto_mode_box_amp_choice_title to "Choose an amplitude:".
set DIC_parameter_window_auto_mode_box_amp_choice_button_suggested to "Suggested Amp".
set DIC_parameter_window_auto_mode_box_amp_choice_button_85 to "Choose 85°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_80 to "Choose 80°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_75 to "Choose 75°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_70 to "Choose 70°".
set DIC_parameter_window_auto_mode_box_amp_choice_button_65 to "Choose 65°".
set DIC_parameter_window_auto_mode_box_suggested_vPitch to "Computed Pitch velocity: ".
set DIC_parameter_window_auto_mode_box_vPitch_choice_title to "Raise the computed velocity?".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_15 to "Serenity choice: +15 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_8 to "Standard choice: +8 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_4 to "Risky choice: +4 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_0 to "Insane choice: +0 m/s".
set DIC_parameter_window_auto_mode_box_vPitch_choice_button_0_forced to "Use vPitch = 0 m/s".
set DIC_parameter_window_auto_mode_box_GTonly_button_name to "GT only".
set DIC_parameter_window_auto_mode_box_GTCirc_button_name to "GT + Circularization".

//--- parameter window ~ manual box
set DIC_parameter_window_manual_mode_box_title to "<b>Wanted values to initiate the GT:</b>".
set DIC_parameter_window_manual_mode_box_amp_title to "Amplitude (between 0 and 90) : ".
set DIC_parameter_window_manual_mode_box_amp_tooltip to "Angle above the horizon.".
set DIC_parameter_window_manual_mode_box_vPitch_title to "Pitch vel. (greater than 0): ".
set DIC_parameter_window_manual_mode_box_vPitch_tooltip to "Pitch velocity in m/s.".
set DIC_parameter_window_manual_mode_box_apoapsis_title to "Apoapsis (min 75_000) :".
set DIC_parameter_window_manual_mode_box_apoapsis_tooltip to "Altitude in m (100_000 recommended).".
set DIC_parameter_window_manual_mode_box_GTonly_button_name to "GT only".
set DIC_parameter_window_manual_mode_box_GTCirc_button_name to "GT + Circularization".

//--- parameter window ~ gtopti box
set DIC_parameter_window_gtopti_mode_box_title to "<b>Looking for the optimal GT</b>".
set DIC_parameter_window_gtopti_mode_box_warning to "<b>WARNING: the research of an optimal GT needs several launches and can take about 10 to 20 minutes. You have nothing to do during the simulation. Stay quietly sit without touching anything or... go grab some snacks!</b>".
set DIC_parameter_window_gtopti_mode_box_button_name to "<b>Start the research of an optimized Gravity Turn!</b>".

//--- parameter window ~ cancel button
set DIC_parameter_window_cancel_button_name to "CANCEL THE SCRIPT AND BACK TO THE CRAFT".

//--- FLIGHT POPUP (gt opti)
set DIC_flight_popup_title to "OPTIMIZATION IN PROGRESS".
set DIC_flight_popup_flight_number_text to "FLIGHT #".
set DIC_flight_popup_test_vPitch_text to "vPitch: ".
set DIC_flight_popup_amp_text to "Amplitude: ".
set DIC_flight_popup_relaunch_text to "Revert to launchpad in:".

//--- ORBIT WINDOW
set DIC_orbit_window_title to "<b>~ ORBIT'S CARACTERISTICS ~</b>".
set DIC_orbit_window_amp_title to "Amp used: ".
set DIC_orbit_window_vPitch_title to "Pitch vel. used: ".
set DIC_orbit_window_APO_name to "Apoapsis: ".
set DIC_orbit_window_PE_name to "Periapsis: ".
set DIC_orbit_window_ARG_PE_name to "Argument of Periapsis: ".
set DIC_orbit_window_ECC_name to "Eccentricity: ".
set DIC_orbit_window_PERIOD_name to "Orbital perdiod: ".
set DIC_orbit_window_INC_name to "Inclination: ".
set DIC_orbit_window_LAN_name to "Longitude of the ascending node: ".
set DIC_orbit_window_button_continue_name to "Continue flight".
set DIC_orbit_window_button_revert_launch_name to "Relaunch*".
set DIC_orbit_window_revert_launch_info to "*Relaunch allows you to test other values for the Amp and the Pitch velocity.".

//--- SPACE WINDOW
set DIC_space_window_title to "<b>~ YOU REACHED SPACE ~</b>".
set DIC_space_window_amp_title to "Amp used: ".
set DIC_space_window_vPitch_title to "Pitch vel. used: ".
set DIC_space_window_button_continue_name to "Continue flight".
set DIC_space_window_button_revert_launch_name to "Relaunch*".
set DIC_space_window_revert_launch_info to "**Relaunch allows you to test other values for the Amp and the Pitch velocity.".

//--- RECAP FILE
set DIC_recap_file_first_line to "Date;Time;Craft's name;Amp;vPitchOpti;Apoapsis;# flights;Test duration;Comments".

//--- RUD FILE
set DIC_rud_file_title to "Emergency stop after an explosion".
set DIC_rud_file_first_line to "Date;Time;Craft's name;Amp;vPitchOpti;Altitude;Velocity;Mission time".

//--- DATA FILE (temp file)
set DIC_data_file_first_line to "startTime;Amp;oldDelta;newDelta;newVpitch;minVpitch;maxVpitch;Apoapsis;Result;numFlight;newAmp?".

//--- FLIGHT STATUS
set DIC_flight_status_success to "SUCCESS".
set DIC_flight_status_failure to "FAILURE".
set DIC_flight_status_newLaunch_text to " - New launch in ".

//--- RECAP WINDOW
set DIC_recap_window_title to "<b>SIMULATION OVER</b>".
set DIC_recap_window_congrats_title to "Congrats! The research of the optimal pitch over for your craft is done!".
set DIC_recap_window_limit to "The research of optimization has reached the limits of our script. Your craft has a vrey hight TWR et its ascension is very aggressive. You might consider to limit its thrust.".
set DIC_recap_window_info_text to "<i>Here are some useful information. You can find them in the file 'recap.csv' located on: \Your_KSP_folder\Ships\Script\OptiGT. Do not delete this folder, it will be used for all your simulations.</i>".
set DIC_recap_window_amp_title to "Amp kept: ".
set DIC_recap_window_vPitch_title to "Opti Pitch Vel. kept: ".
set DIC_recap_window_number_flights_title to "Number of flights done: ".
set DIC_recap_window_simulation_time_title to "Total duration of the simulation: ".
set DIC_recap_window_add_description_text to "If you wish, you can write a short comment below. It will be saved in the 'recap.csv' file.".
set DIC_recap_window_add_description_tooltip to "short comment: warning, no line break...".
set DIC_recap_window_final_decision_text to "Do you want to go back to the VAB or reload you craft on the launchpad?".
set DIC_recap_window_VAB_text to "VAB".
set DIC_recap_window_launchPad_text to "Launchpad".
set DIC_recap_window_save_recap_button_text to "Save the flights data int he Script folder.".
set DIC_recap_window_save_recap_button_text_already_saved to "Flights data saved in Script/".

//--- STARTING A SIMULATION WITH A NEW FLIGHT
set DIC_new_sim_window_info to "It appears that a simulation is already running with a different craft. For an unknown reason, the following simulation was stopped:".

set DIC_new_sim_window_info_craft_name to "Craft's name:".
set DIC_new_sim_window_info_date to "Date:".
set DIC_new_sim_window_info_time to "Time:".
set DIC_new_sim_window_info_Amp to "Amp:".
set DIC_new_sim_window_info_vPitch to "vPitch:".

set DIC_new_sim_window_info_question to "Do you wish to go back to the VAB to reload the previous vessel and continue the simulation or do you wish to start over the script with the actual ship (the last simulation will be definitively deleted)?".

set DIC_new_sim_window_button_change_text to "Change vessel (VAB)".
set DIC_new_sim_window_button_keep_text to "Keep this vessel".

//--- RESET A SIMULATION WITH THE ACTUAL FLIGHT
set DIC_reset_sim_window_info to "It appears that a simulation is already running with this craft. For an unknown reason, the simulation was stopped. Here is the known information:".

set DIC_reset_sim_window_info_date to "Date:".
set DIC_reset_sim_window_info_time to "Time:".
set DIC_reset_sim_window_info_Amp to "Amp:".
set DIC_reset_sim_window_info_vPitch to "vPitch:".

set DIC_reset_sim_window_info_question to "Do you wish to go continue the simulation or do you wish to start over the script (the last simulation will be definitively deleted)?".

set DIC_reset_sim_window_button_continue_text to "Continue simulation".
set DIC_reset_sim_window_button_new_text to "New simulation".

//--- ABORT POPUP
set DIC_abort_popup_title to "<b>EMERGENCY STOP</b>".
set DIC_abort_popup_info to "Unusual overheat. Quickly press that button! QUIIIICK! ".
set DIC_abort_popup_button_text to "ABORT".

//--- warning high TWR window
set DIC_warningTWR_popup_title to "<b>EXCESSIVE TWR</b>".
set DIC_warningTWR_popup_info_one to "Your TWR exceeds our model. Even with a high majoration, the computed vPitch is negative and should be set to 0.".
set DIC_warningTWR_popup_info_two to "A high TWR at the launchpad is meaningless: we suggest to keep your TWR between 1.2 and 2 at the launchpad.".
set DIC_warningTWR_popup_button_text to "UNDERSTOOD".

//--- PRO POPUP
set DIC_pro_popup_title to "<b>I AM A PRO</b>".
set DIC_pro_popup_success_text to "I'm able to recognize that the current flight will suceed. The vPitch must be raised.".
set DIC_pro_popup_success_button to "GT TOO LATE".
set DIC_pro_popup_failure_text to "I'm able to recognize that the current flight will fail. The vPitch must be lowered.".
set DIC_pro_popup_failure_button to "GT TOO SOON".
set DIC_pro_popup_staging_text to "I need to jettison this stage. Why? Because I'm the boss!".
set DIC_pro_popup_staging_button to "STAGE NOW".