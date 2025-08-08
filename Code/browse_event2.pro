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

pro browse_event_pan, event
  widget_control, event.id, get_uvalue=tag
  widget_control, event.top, get_uvalue=uvalue

  file_pan = dialog_pickfile(title='Select PAN Image')

  if file_pan ne '' then begin
    uvalue.pan = file_pan
    widget_control, event.top, set_uvalue=uvalue
  endif
end

pro browse_event_ms, event
  widget_control, event.id, get_uvalue=tag
  widget_control, event.top, get_uvalue=uvalue

  file_ms = dialog_pickfile(title='Select MS Image')
  
  if file_ms ne '' then begin
    uvalue.ms = file_ms
    widget_control, event.top, set_uvalue=uvalue
  endif
end


pro text_event_pan, event
  ; Recupera la struttura 'state' dal widget principale
  widget_control, event.top, get_uvalue=state
  widget_control, event.id, get_value=val
  state.numeric_value_pan = float(val)
  widget_control, event.top, set_uvalue=state
end

pro text_event_ms, event
  ; Recupera la struttura 'state' dal widget principale
  widget_control, event.top, get_uvalue=state
  widget_control, event.id, get_value=val
  state.numeric_value_ms = float(val)
  widget_control, event.top, set_uvalue=state
end
