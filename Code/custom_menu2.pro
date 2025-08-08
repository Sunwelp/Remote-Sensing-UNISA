;
; Course: High Performance Computing 2023/2024
; 
; Lecturer: Paolo Addesso paddesso@unisa.it
;
; Students:
; Pepe Lorenzo          0622702121      l.pepe29@studenti.unisa.it
; Carrozza Franscesco   0622702061      f.carrozza2@studenti.unisa.it
; Ciaravolo Ciro        0622702006      c.ciaravolo17@studenti.unisa.it
; Marcone Giuseppe      0622701896      g.marcone2@studenti.unisa.it
;
;               REQUIREMENTS OF THE ASSIGNMENT:
; Implements and test three pansharpening algorithms in IDL (HPF, Brovey and GIHS) using Envi, 
; developing an UI to manage remote sensed images.
;
; Copyright (C) 2024 - All Rights Reserved
;
; This program is free software: you can redistribute it and/or modify it under the terms of 
; the GNU General Public License as published by the Free Software Foundation, either version 
; 3 of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
; See the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along with ContestOMP. 
; If not, see <http://www.gnu.org/licenses/>.
;
pro custom_menu2, event
  compile_opt idl2
  base = WIDGET_BASE(title='Custom Image Processing', column=1, XSIZE=300, YSIZE=300)
  uvalue = {pan: '', ms: '', algo: '', numeric_value_pan: '', numeric_value_ms: ''}
  widget_control, base, set_uvalue=uvalue
  
  hbox_pan = WIDGET_BASE(base, /ROW)
  label_pan = widget_label(hbox_pan, value='Load PAN Image:')
  button_pan = widget_button(hbox_pan, value='Browse...', uvalue='pan', event_pro='browse_event_pan')

  hbox_pan2 = WIDGET_BASE(base, /ROW)
  label_ms = widget_label(hbox_pan2, value='Load MS Image:')
  button_ms = widget_button(hbox_pan2, value='Browse...', uvalue='ms', event_pro='browse_event_ms')
 
  hbox_pan4 = WIDGET_BASE(base, /ROW)
  label_algo = widget_label(hbox_pan4, value='Run with...')
  ihs_process = widget_button(hbox_pan4, value='GIHS', uvalue='ihs', event_pro='process_event')
  brovey_process = widget_button(hbox_pan4, value='Brovey', uvalue='brovey', event_pro='process_event')
  
  hbox_pan7 = WIDGET_BASE(base, /ROW)
  label_text = widget_label(hbox_pan7, value='If you choose HPF specify the Ground Sampling Distance:')
  
  hbox_pan3 = WIDGET_BASE(base, /ROW)
  label_text_pan = widget_label(hbox_pan3, value='GSD PAN')
  gsd_pan = widget_text(hbox_pan3, /editable, value='0.0', uvalue='numeric_value', event_pro='text_event_pan')
  hbox_pan5 = WIDGET_BASE(base, /ROW)
  label_text_ms = widget_label(hbox_pan5, value='GSD MS ')
  gsd_ms = widget_text(hbox_pan5, /editable, value='0.0', uvalue='numeric_value', event_pro='text_event_ms')
  
  hbox_pan6 = WIDGET_BASE(base, /ROW)
  hpf_process = widget_button(hbox_pan6, value='HPF', uvalue='hpf', event_pro='process_event')
  
  hbox_pan8 = WIDGET_BASE(base, /ROW)
  label_text = widget_label(hbox_pan8, value='The output file will be saved in the PAN folder!')

  ; Crea un hash per conservare i percorsi dei file e l'algoritmo selezionato
  widget_control, base, /realize

  xmanager, 'custom_menu', base

end