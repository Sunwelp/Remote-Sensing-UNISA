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
pro process_event, event
  ; Recupera la struttura 'state' dal widget principale
  widget_control, event.top, get_uvalue=state
  widget_control, event.id, get_uvalue=tag

  ; Recupera i file PAN e MS dalla struttura 'state'
  file_pan = state.pan
  file_ms = state.ms
  val_pan = state.numeric_value_pan
  val_ms = state.numeric_value_ms

  ; Leggi le immagini dai file selezionati
  i_pan = Read_Tiff(file_pan)
  i_ms = Read_Tiff(file_ms)

  ; Esegui l'elaborazione basata sull'algoritmo selezionato
  case tag of
    'ihs': I_Fus = IHS_fun(i_ms, i_pan)
    'brovey': I_Fus = func_Brovey(i_ms, i_pan)
    'hpf': I_Fus = HPF_fun(i_ms, i_pan, val_pan, val_ms)
  endcase


  dir = file_dirname(file_pan)
  ; Specifica il percorso di output per l'immagine fusa
  ;path = 'C:\Users\macch\OneDrive\Desktop\Remote sensing\IHS\Nuova.tif'
  path = dir + "\output.tif"
  print, path
  Write_Tiff, path, I_Fus, /DOUBLE

  print, "Fusion completed!"
end
