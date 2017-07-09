#!/usr/bin/env python
import bs4 as bs
import urllib.request
import itertools
import sys

def main():
	# Define variables
	urls = { 
			'redhat6':  'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Package_Manifest/index.html',
			'redhat7':  'https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7//html-single/Package_Manifest/index.html'
			}
	column = 1
	filenames = [
			'redhat6_packages.txt',
			'redhat7_packages.txt',
			'intersect_packages.txt',
			'unique_in_redhat6.txt',
			'unique_in_redhat7.txt'
			]

	# Begin program
	packages = dict()

	# Loop through each URL
	for key, url in urls.items():

		 # Get HTML content from url and organize
		 # with BeautifulSoup
		 soup = get_soup(url)

		 # Get only the values from tables at the specified column
		 packages[key] = get_redhat_table_data(soup, column)

	# Create two sets containing all the packages
	# for each version
	redhat6 = set(packages['redhat6'])
	redhat7 = set(packages['redhat7'])

	# Create new sets from results
	intersect_packages = redhat6.intersection(redhat7)
	unique_in_redhat6 = redhat6.difference(redhat7)
	unique_in_redhat7 = redhat7.difference(redhat6)

	# Write results to corresponding files
	write_set_results(filenames[0], redhat6)
	write_set_results(filenames[1], redhat7)
	write_set_results(filenames[2], intersect_packages)
	write_set_results(filenames[3], unique_in_redhat6)
	write_set_results(filenames[4], unique_in_redhat7)
		
def get_soup(url):
	""" 
		INPUT: 
		  - url

		OUTPUT: 
		  - bs4.BeautifulSoup

	"""

	try:
		data = urllib.request.urlopen(url).read()
	except urllib.error.URLError:
		print("Error: issue connecting to url {0}".format(url))
		print("Ensure you are using a valid url")
		sys.exit(1)

	soup = bs.BeautifulSoup(data, "html.parser")
	return soup

def get_redhat_table_data(soup, column):
	"""
		Parses HTML specific to RedHats package manifest.
		Relevant packages are nested in a <div> tag with a
		class value of 'informaltable'

		INPUT: 
		  - bs4.BeautifulSoup
		  - integer representing which column values to return

		OUTPUT: 
		  - list

	"""
	
	raw_data = list()

	for table in soup.find_all('div', { 'class': 'informaltable'} ):
		for tr in table.find_all('tr'):
			try:
				raw_data.append(tr.select('td')[(column - 1)].text)
			except:
				pass

	data = [ line.strip(' \n\t\r') for line in raw_data ]
	return data

def write_set_results(filename, set):
	"""
		writes values of set to file

		INPUT:
		  - filename
		  - set

		OUTPUT:
		  - None

	"""

	with open(filename, 'w') as f_hand:
		for package in sorted(set):
			f_hand.write(package + '\n')

main()
