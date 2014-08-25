

procedure turbulence_textgrid_tiers
  # String constants for the tiers of a Turbulence Tagging TextGrid.
  .cons_type    = 1
  .cons_type$   = "ConsType"
  .turb_events  = 2
  .turb_events$ = "TurbEvents"
  .turb_notes   = 3
  .turb_notes$  = "TurbNotes"
  # Gather the string constants into a vector.
  .slot1$ = .cons_type$
  .slot2$ = .turb_events$
  .slot3$ = .turb_notes$
  .length = 3
  # A few other string constants that facilitate creating a new
  # Segmentation TextGrid.
  .all_tiers$ = .slot1$
  for i from 2 to .length
    .all_tiers$ = .all_tiers$ + " " + .slot'i'$
  endfor
  .point_tiers$ = .turb_events$
endproc


procedure read_turbulence_textgrid
  # Use the [.directory$] and [.filename$] strings to set up the path
  # from which the Turbulence Tagging TextGrid is [.read_from$].
  .read_from$ = turbulence_textgrid.directory$ + "/" + 
            ... filename_from_pattern.filename$
  # The [.write_to$] path is the same as the [.read_from$] path.
  .write_to$ = .read_from$
  # Read in the Turbulence Tagging TextGrid
  printline Loading Turbulence Tagging TextGrid
        ... 'filename_from_pattern.filename$' from
        ... 'turbulence_textgrid.directory$'
  Read from file... '.read_from$'
  Rename... 'turbulence_textgrid.textgrid_obj$'
  .praat_obj$ = selected$()
endproc


procedure initialize_turbulence_textgrid
  # The [.read_from$] path is an empty string because the Turbulence Tagging
  # TextGrid was not read from the filesystem.
  .read_from$ = ""
  # Set up the path that the Turbulence Tagging TextGrid will be written to.
  .write_to$ = turbulence_textgrid.directory$ + "/" +
           ... turbulence_textgrid.experimental_task$ + "_" +
           ... participant.id$ + "_" +
           ... turbulence_textgrid.initials$ + "turb.TextGrid"
  # Create a blank Turbulence Tagging TextGrid by annotating the audio object.
  printline Initializing blank Turbulence Tagging TextGrid
        ... 'turbulence_textgrid.textgrid_obj$'
  select 'audio.praat_obj$'
  To TextGrid... "'turbulence_textgrid_tiers.all_tiers$'"
             ... 'turbulence_textgrid_tiers.point_tiers$'
  Rename... 'turbulence_textgrid.textgrid_obj$'
  .praat_obj$ = selected$()
endproc


procedure turbulence_textgrid_error: .directory$ 
                                     ... .participant_number$
  printline
  printline
  printline <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>>
  printline
  printline ERROR :: No Turbulence Tagging TextGrid was loaded
  printline
  printline Make sure the following directory exists on your computer:
  printline '.directory$'
  printline 
  printline Also, make sure that directory contains a Turbulence Tagging
        ... TextGrid for participant '.participant_number$'.
  printline
  printline <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>> <<<>>>
  printline
  printline 
endproc



procedure turbulence_textgrid
  # Import constants from the [session_parameters] namespace.
  .initials$             = session_parameters.initials$
  .workstation$          = session_parameters.workstation$
  .experimental_task$    = session_parameters.experimental_task$
  .testwave$             = session_parameters.testwave$
  .participant_number$   = session_parameters.participant_number$
  .activity$             = session_parameters.activity$
  .experiment_directory$ = session_parameters.experiment_directory$
  # Set up the [turbulence_textgrid_tiers] namespace.
  @turbulence_textgrid_tiers
  # Only load a Turbulence Tagging TextGrid if the Turbulence Tagging Log has
  # been loaded to the Praat Objects list.
  if turbulence_log.praat_obj$ <> ""
    # If a Turbulence Tagging Log has been loaded to the Praat Objects list, 
    # then load a Turbulence Tagging TextGrid.
    # Use the path that the Turbulence Tagging Log was [.read_from$] to 
    # determine the [participant]'s [.id$].
    @participant: turbulence_log.write_to$, .participant_number$
    # Use the [participant]'s [.id$] to set up the name of the TextGrid object.
    .textgrid_obj$ = participant.id$ + "_TurbTextGrid" + .initials$
    # Set up the path to the [.directory$] of the Turbulence Tagging TextGrids.
    .directory$ = .experiment_directory$ + "/" + 
              ... "TurbulenceTagging" + "/" + 
              ... "TextGrids"
    # Set up the string [.pattern$] used to search for a Turbulence Tagging
    # TextGrid.
    .pattern$ = .directory$ + "/" +
            ... .experimental_task$ + "_" +
            ... .participant_number$ + "*" + 
            ... .initials$ + "turb.TextGrid"
    # Use the [.pattern$] to search for a Turbulence Tagging Log.
    @filename_from_pattern: .pattern$, "Turbulence Tagging Log"
    if filename_from_pattern.filename$ <> ""
      # If a Turbulence Tagging TextGrid was found on the filesystem, then read
      # it in.
      @read_turbulence_textgrid
      # Import string constants from the [read_turbulence_textgrid] namespace.
      .read_from$ = read_turbulence_textgrid.read_from$
      .write_to$  = read_turbulence_textgrid.write_to$
      .praat_obj$ = read_turbulence_textgrid.praat_obj$
    else
      # If no Turbulence Tagging TextGrid was found on the filesystem, then
      # create a blank one at run time.
      @initialize_turbulence_textgrid
      # Import string constants from the [initialize_turbulence_textgrid]
      # namespace.
      .read_from$ = initialize_turbulence_textgrid.read_from$
      .write_to$  = initialize_turbulence_textgrid.write_to$
      .praat_obj$ = initialize_turbulence_textgrid.praat_obj$
    endif
  else
    # If a Turbulence Tagging Log has not been loaded to the Praat Objects list,
    # then don't load a Turbulence Tagging TextGrid.
    .read_from$ = ""
    .write_to$  = ""
    .praat_obj$ = ""
  endif
endproc



