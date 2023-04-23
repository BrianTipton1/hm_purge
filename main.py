import re
import os

HM_REGEX = r'((\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})) : id (\d+) -> .*'

s = os.popen('home-manager generations')
output = s.read()
generations = output.split('\n')

ids = []
for gen in generations:
    m = re.match(HM_REGEX, gen)
    if m is not None:
        ids.append(int(m.group(7)))
ids.sort()
ids.pop()

print(f'Removing {len(ids)} generations')
for i in ids:
    os.system(f'home-manager remove-generations {i}')