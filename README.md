# LSTM_Lipreader
LSTM Based Lipreader using President Obama's weekly addresses as a training set.  It is hoped that this dataset
will also be found useful for training speech recognition models.  The data consists of >1.5 million face-cropped
images (96 x 96 x 3), as well as isolated mouth images (40 x 40, grayscale), the corresponding sound samples for
each frame (sampled at 25 or 30 fps, depending on video) and the corresponding caption files, in vtt form.  These
caption files, along with audio power RMS detection in the samples themselves, were used to build frame-wise estimates
of where each word is spoken in each video.  There are >8000 unique words in these videos, (>205k words in all) with
>3000 words spoken at least 5 times (which will yield 10 training examples with the images flipped across their 
horizontal axis)

This Repo holds matlab files used to process avi files, split them into images and sound samples at 
various (user selectable) sample rates, and then take face-isolated and mouth-isolated images and use
them to train sequential learning algorithms.

This repo also holds data pertaining to estimated frame-wise caption locations for labels for each spoken
word.

The data used for this project was acquired from the weekly addresses of President Obama from 2009-2015, which 
consisted of 310 4-8 minute videos.  The data can be found here : 

https://www.dropbox.com/sh/21m2byeocbbl2wg/AACPePzQlU-YOcOzKy7W6Rwpa?dl=0

This link will expire on 6/1/2016. After this date, please email this jturner65@gatech.edu to get access.

Included in this dataset is also a 100 x 100 node torroidal hex SOM trained on the audio data of the first 
130 of the videos.  The library used to build this SOM is somoclu, found here : https://github.com/peterwittek/somoclu
This reduces the dimensions of the audio samples from ~1760 

