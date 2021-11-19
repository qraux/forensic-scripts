# Dump frames from multiple video files
# Usage: dumpframes.py path_to_videos
# Prerequisites: Python 3 and ffmpeg
# v0.94

import os
import sys
import subprocess

def main():
	os.system('clear')
	pathffmpeg="/bin/ffmpeg"
	
	if not os.path.isfile(pathffmpeg):
		print("ffmpeg meybe not installed")
		sys.exit()
	if len(sys.argv) != 2:
		print("Invalid number of arguments.")
		sys.exit()
	
	path=sys.argv[1]
	
	if path == "-h":
		print("Usage: python3 dumpframes.py /home/John/movies")
		sys.exit()	
	if not os.path.exists(path):
		sys.exit()

	for filename in os.listdir(path):
		filepath = os.path.join(path,filename)
		try:
			outpath=str(filepath) + str(".iframes")
			os.mkdir(outpath)
			print("Output folder created: " + outpath)
		except FileExistsError:
			print("Output folder already excist.")
			sys.exit()
						
		if os.path.isfile(filepath):
			print('Passed file check ('+str(filepath) + ")")
			outfile=str(outpath) + str("/thumb%000004d.png")
			print("Outfile: " + outfile)
			try:
				print("Try dumping: " + filepath)
				subprocess.check_call([r"/bin/ffmpeg", "-i", filepath, outfile, "-hide_banner"])
				print("Successfully dumped iframes (" + filepath + ")")
			except subprocess.CalledProcessError as e:
				print("Failed dumping iframes (" + filepath +")")
				print(e)
				sys.exit()
			
if __name__ == '__main__':
	main()
