import filecmp
import json
import os

import requests

es_url = os.environ.get('ELASTICSEARCH_URL', 'http://elasticsearch.marathon.mesos:31105')

while True:

    response = requests.get('%s/v1/tasks' % es_url)
    endpoints = [x['http_address'] for x in json.loads(response.text)]

    print('endpoints found: %s' % json.dumps(endpoints))
    conf_file = 'logstash.conf'
    with open('%s-template' % conf_file) as in_conf:
        conf_string = in_conf.read()
        conf_string = conf_string.replace('_ES_HOSTS_', json.dumps(endpoints))
        with open('%s_tmp' % conf_file, 'w') as out_conf:
            out_conf.write(conf_string)

    if not (os.path.isfile(conf_file) and filecmp.cmp(conf_file, '%s_tmp' % conf_file)):
        print('Elastic Search endpoint update detected. Applying new config...")
        os.rename('%s_tmp' % conf_file, conf_file)
        
