
# A procedure that defines the structure of the TextGrid that is displayed in
# the Editor window during turbulence tagging.
# The first four tiers (Word, Context, Repetition, and SegmNotes) are 
# extracted from the Segmentation TextGrid.  The last three tiers are modified
# during turbulence tagging, and it is only these last three tiers (ConsType,
# TurbEvents, and TurbNotes) that are output to the TurbulenceTagging/TextGrids
# directory.
procedure turbulence_textgrid_tiers
  # String constants for the tiers of a Turbulence Tagging TextGrid.
  .trial        = 1
  .trial$       = "Trial"
  .context      = 2
  .context$     = "Context"
  .repetition   = 3
  .repetition$  = "Repetition"
  .segm_notes   = 4
  .segm_notes$  = "SegmNotes"
  .cons_type    = 5
  .cons_type$   = "ConsType"
  .turb_events  = 6
  .turb_events$ = "TurbEvents"
  .turb_notes   = 7
  .turb_notes$  = "TurbNotes"
  # Gather the string constants into a vector.
  .slot1$ = .trial$
  .slot2$ = .context$
  .slot3$ = .repetition$
  .slot4$ = .segm_notes$
  .slot5$ = .cons_type$
  .slot6$ = .turb_events$
  .slot7$ = .turb_notes$
  .length = 7
  # String constants that facilitate creating a new
  # Turbulence TextGrid.
  .all_tiers$ = .slot1$
  for i from 2 to .length
    .all_tiers$ = .all_tiers$ + " " + .slot'i'$
  endfor
  .point_tiers$ = .segm_notes$ + " " + .turb_events$
  # String constants that facilitate creating a new TextGrid of just the
  # Turbulence Tagging tiers.
  .all_turbulence_tiers$ = .cons_type$ + " " + .turb_events$ + " " +
                       ... .turb_notes$
  .turbulence_point_tiers$ = .turb_events$ + " " +.turb_notes$
endproc


# A procedure for extracting the four tiers from the Segmentation TextGrid that
# are the first four tiers of the TextGrid displayed in the Editor window during
# turbulence tagging.
# This procedure presupposes that the procedure @segmentation_textgrid has been
# called previously.
procedure segmentation_tiers
  # Extract the four Segmentation tiers individually...
  printline Extracting Segmentation tiers from
        ... 'segmentation_textgrid.praat_obj$'
  # ... the Word tier;
  select 'segmentation_textgrid.praat_obj$'
  Extract one tier... 'segmentation_textgrid_tiers.trial'
  # ... the Context tier;
  select 'segmentation_textgrid.praat_obj$'
  Extract one tier... 'segmentation_textgrid_tiers.context'
  # ... the Repetition tier;
  select 'segmentation_textgrid.praat_obj$'
  Extract one tier... 'segmentation_textgrid_tiers.repetition'
  # ... and the SegmNotes tier.
  select 'segmentation_textgrid.praat_obj$'
  Extract one tier... 'segmentation_textgrid_tiers.segm_notes'
  # Extracting the four tiers will have created four new TextGrids in Praat's
  # Objects list.  Select these four TextGrid objects together...
  select TextGrid 'segmentation_textgrid_tiers.trial$'
  plus TextGrid 'segmentation_textgrid_tiers.context$'
  plus TextGrid 'segmentation_textgrid_tiers.repetition$'
  plus TextGrid 'segmentation_textgrid_tiers.segm_notes$'
  # ... and then merge them into a single TextGrid.
  Merge
  # Rename the merged TextGrid to individuate it on Praat's Objects list, and
  # store this new name in the local variable [.praat_obj$].
  Rename... SegmentationTiers
  .praat_obj$ = selected$()
  # Remove the four TextGrid objects that were extracted from the Segmentation
  # TextGrid.
  select TextGrid 'segmentation_textgrid_tiers.trial$'
  plus TextGrid 'segmentation_textgrid_tiers.context$'
  plus TextGrid 'segmentation_textgrid_tiers.repetition$'
  plus TextGrid 'segmentation_textgrid_tiers.segm_notes$'
  Remove
endproc


# A procedure for concatenating various strings to form a string-pattern that
# is used to search the filesystem for TextGrid containing the three 
# "Turbulence Tiers", i.e. the ConsType, TurbEvents, and TurbNotes tiers that
# are modified during turbulence tagging.
procedure turbulence_tiers_pattern
  # Import constants from the [session_parameters] namespace.
   .initials$             = session_parameters.initials$
   .experimental_task$    = session_parameters.experimental_task$
   .participant_number$   = session_parameters.participant_number$
   .experiment_directory$ = session_parameters.experiment_directory$
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
endproc


# A procedure for reading, from the filesystem, a TextGrid that contains the 
# Turbulence Tagging tiers.
procedure read_turbulence_tiers
  # Use the [.directory$] and [.filename$] strings to set up the path
  # from which the Turbulence Tagging TextGrid is [.read_from$].
  .read_from$ = turbulence_tiers_pattern.directory$ + "/" + 
            ... filename_from_pattern.filename$
  # The [.write_to$] path is the same as the [.read_from$] path.
  .write_to$ = .read_from$
  # Read in the Turbulence Tagging tiers
  printline Loading Turbulence Tagging tiers from
        ... 'filename_from_pattern.filename$' (found in
        ... 'turbulence_tiers_pattern.directory$')
  Read from file... '.read_from$'
  Rename... TurbulenceTiers
  .praat_obj$ = selected$()
endproc


# A procedure for creating, from scratch, a TextGrid that contains the
# Turbulence Tagging tiers.
procedure initialize_turbulence_tiers
  # The [.read_from$] path is an empty string because the Turbulence Tagging
  # TextGrid was not read from the filesystem.
  .read_from$ = ""
  # Set up the path that the Turbulence Tagging TextGrid will be written to.
  .write_to$ = turbulence_tiers_pattern.directory$ + "/" +
           ... turbulence_textgrid.experimental_task$ + "_" +
           ... participant.id$ + "_" +
           ... turbulence_textgrid.initials$ + "turb.TextGrid"
  # Create a blank Turbulence Tagging TextGrid by annotating the audio object.
  printline Initializing Turbulence Tagging tiers
  select 'audio.praat_obj$'
  To TextGrid... "'turbulence_textgrid_tiers.all_turbulence_tiers$'"
             ... 'turbulence_textgrid_tiers.turbulence_point_tiers$'
  Rename... TurbulenceTiers
  .praat_obj$ = selected$()
endproc


# A procedure for loading the Turbulence Tagging tiers.
procedure turbulence_tiers
  # Search for the Turbulence Tagging tiers on the filesystem.
  @turbulence_tiers_pattern
  @filename_from_pattern: turbulence_tiers_pattern.pattern$, 
                      ... "Turbulence Tagging TextGrid"
  if filename_from_pattern.filename$ <> ""
    # If the Turbulence Tagging tiers were found on the filesystem, then read
    # them in.
    @read_turbulence_tiers
    # Import string constants from the [read_turbulence_tiers] namespace.
    .read_from$ = read_turbulence_tiers.read_from$
    .write_to$  = read_turbulence_tiers.write_to$
    .praat_obj$ = read_turbulence_tiers.praat_obj$
  else
    # If the Turbulence Tagging tiers were not found on the filesystem, then
    # create them at run time.
    @initialize_turbulence_tiers
    # Import string constants from the [initialize_turbulence_tiers]
    # namespace.
    .read_from$ = initialize_turbulence_tiers.read_from$
    .write_to$  = initialize_turbulence_tiers.write_to$
    .praat_obj$ = initialize_turbulence_tiers.praat_obj$
  endif
endproc


# A procedure for merging the Segmentation tiers and the Turbulence Tagging
# tiers.
procedure merge_segmentation_and_turbulence_tiers
  # Print a message.
  printline Merging Segmentation tiers and Turbulence Tagging tiers into
        ... TextGrid 'turbulence_tiers_pattern.textgrid_obj$'
  # Select the SegmentationTiers and the TurbulenceTiers TextGrids.
  select 'segmentation_tiers.praat_obj$'
  plus 'turbulence_tiers.praat_obj$'
  # Merge them together.
  Merge
  # Rename the merged TextGrid.
  Rename... 'turbulence_tiers_pattern.textgrid_obj$'
  # Remove the SegmentationTiers and TurbulenceTiers TextGrids from Praat's
  # Objects list.
  select 'segmentation_tiers.praat_obj$'
  plus 'turbulence_tiers.praat_obj$'
  Remove
endproc


# A procedure for saving the Turbulence Tagging tiers from the Turbulence
# Tagging TextGrid.
procedure save_turbulence_tiers
  # Extract the three Turbulence Tagging tiers individually...
  # ... the ConsType tier;
  select 'turbulence_textgrid.praat_obj$'
  Extract one tier... 'turbulence_textgrid_tiers.cons_type'
  # ... the TurbEvents tier;
  select 'turbulence_textgrid.praat_obj$'
  Extract one tier... 'turbulence_textgrid_tiers.turb_events'
  # ... the TurbNotes tier;
  select 'turbulence_textgrid.praat_obj$'
  Extract one tier... 'turbulence_textgrid_tiers.turb_notes'
  # Extracting the Turbulence Tagging tiers will have created three new
  # TextGrids on Praat's Objects list.  Select these three TextGrid objects
  # together...
  select TextGrid 'turbulence_textgrid_tiers.cons_type$'
  plus TextGrid 'turbulence_textgrid_tiers.turb_events$'
  plus TextGrid 'turbulence_textgrid_tiers.turb_notes$'
  # ... and then merge them into a single TextGrid.
  Merge
  # Save the merged TextGrid
  Save as text file... 'turbulence_textgrid.write_to$'
  # Remove the three Turbulence Tagging tiers and the merged TextGrid.
  select TextGrid 'turbulence_textgrid_tiers.cons_type$'
  plus TextGrid 'turbulence_textgrid_tiers.turb_events$'
  plus TextGrid 'turbulence_textgrid_tiers.turb_notes$'
  plus TextGrid merged
  Remove
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
    # then a Segmentation TextGrid has also been loaded (cf. the definition of
    # the @turbulence_log procedure in L2T-TurbulenceLog.praat).  So, extract,
    # from the Segmentation TextGrid, the four segmentation tiers that are 
    # a part of the TextGrid displayed during turbulence tagging.
    @segmentation_tiers
    # Load the Turbulence Tagging tiers.
    @turbulence_tiers
    # Merge the Segmentation tiers and the Turbulence Tagging tiers.
    @merge_segmentation_and_turbulence_tiers
    # Import the [.read_from$] and [.write_to$] variables from the 
    # [turbulence_tiers] namespace.
    .read_from$ = turbulence_tiers.read_from$
    .write_to$  = turbulence_tiers.write_to$
    # Import the [.praat_obj$] from the [turbulence_tiers_pattern] namespace.
    select TextGrid 'turbulence_tiers_pattern.textgrid_obj$'
    .praat_obj$ = selected$()
  else
    # If a Turbulence Tagging Log has not been loaded to the Praat Objects list,
    # then don't load a Turbulence Tagging TextGrid.
    .read_from$ = ""
    .write_to$  = ""
    .praat_obj$ = ""
  endif
endproc



