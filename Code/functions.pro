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

function IHS_fun, I_MS, I_PAN

  image_HR = double(I_PAN)
  image_LR = double(I_MS)
  dims = size(image_LR, /dimension)
  dims_pan = size(image_HR, /dimensions) 
  IF (dims[1] LT dims_pan[0]) THEN BEGIN
    image_LR = CONGRID(image_LR, dims[0], dims_pan[0], dims_pan[1], /INTERP)
    dims = SIZE(image_LR, /DIMENSIONS)
  ENDIF
  I = mean(image_LR, dimension=1)
  meanIHR = mean(image_HR)
  meanI = mean(I) 
  stdIHR = stddev(image_HR)  
  stdI = stddev(I)
  image_HR = (image_HR-meanIHR)*(stdI/stdIHR)+meanI

  D = image_HR-I
  image_FUS = image_LR
  for i=0, dims[0]-1 do begin
    image_FUS[i, *, *] = image_LR[i, *, *] + D
  endfor

  return, image_FUS

end

function func_Brovey, I_MS, I_PAN

  imageLR = double(I_MS)
  imageHR = double(I_PAN)
  
  dims = size(imageLR, /dimension)
  dims_pan = size(imageHR, /dimensions)

  IF (dims[1] LT dims_pan[0]) THEN BEGIN
    imageLR = CONGRID(imageLR, dims[0], dims_pan[0], dims_pan[1], /INTERP)
    dims = SIZE(imageLR, /DIMENSIONS)
  ENDIF
  

  I = mean(imageLR, dimension=1)

  mean_imageHR = mean(imageHR)
  std_imageHR = stddev(imageHR)
  mean_I = mean(I)
  std_I = stddev(I)
  imageHR = (imageHR - mean_imageHR)*(std_I / std_imageHR) + mean_I

  epsilon = 1e-12
  ratio = imageHR / (I+epsilon)
  n_bands = dims[0]
  I_Fus_Brovey = imageLR

  for i=0, n_bands-1 do begin
    I_Fus_Brovey[i, *, *] = imageLR[i, *, *]*ratio
  endfor

  return, I_Fus_Brovey
end

FUNCTION HPF_fun, ms_image, pan_image, GSD_Pan, GSD_Ms
print, "GDS_PAN:", GSD_PAN
print, "GDS_MS:", GSD_MS
  ; Get images dimensions
  dims_ms = SIZE(ms_image, /DIMENSIONS)
  dims_pan = SIZE(pan_image, /DIMENSIONS)
  ; Cast both imagfes to float, avoiding overflow/underflow effects
  ms_image = FLOAT(ms_image)
  pan_image = FLOAT(pan_image)

  IF (dims_ms[1] LT dims_pan[0]) THEN BEGIN
    ms_image = CONGRID(ms_image, dims_ms[0], dims_pan[0], dims_pan[1], /INTERP)
    ; Get the new MS image dimensions
    dims_ms = SIZE(ms_image, /DIMENSIONS)
  ENDIF

  ; Compute the kernel size, based on the GSG of MS and PAN sensor. If forbidden value are
  ; inserted, kernel size is fixed to 5.
  IF ((GSD_Ms EQ '' || GSD_Pan EQ '') || (GSD_Ms EQ '0.0' || GSD_Pan EQ '0.0') || $
    (GSD_Ms LT '0' || GSD_Pan LT '0') || (GSD_Ms GT '30' || GSD_Pan GT '30')) THEN BEGIN
    kSize = 5
  ENDIF ELSE BEGIN
    r = GSD_Ms/GSD_Pan
    kSize = FIX((2*r)+1)
  ENDELSE

  ; Apply the Low Pass Filter to the Panchromatic iamge
  smoothed_pan = SMOOTH(pan_image, kSize, /EDGE_MIRROR)

  ; Extract the edge-features from the Panchromatic image
  hpf_pan = pan_image - smoothed_pan

  ; Create an MS-like Panchromatic Image (replicating the Pan Image for each MS Bands)
  fused_image = FLTARR(dims_ms[0], dims_ms[1], dims_ms[2])

  ; Apply the edge features to each MS bands
  FOR b = 0, dims_ms[0] - 1 DO BEGIN
    fused_image[b,*,*] = ms_image[b,*,*] + hpf_pan
  ENDFOR

  ; Return the fused HPF image
  RETURN, fused_image
END

