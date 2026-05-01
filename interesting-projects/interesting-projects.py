import pathlib
import random


class Link:
    def __init__(self, s):
        self.link, *rest = s.split("\n")
        self.tags = [l for l in rest if l.startswith(":")]
        self.gemtext = "\n".join([l for l in rest if not l.startswith(":")])

    def __repr__(self):
        return repr(self.__dict__)

    def __str__(self):
        res = ""
        res += self.link
        res += "\n"
        res += self.gemtext
        res += "\n"
        res += " ".join(self.tags)
        return res

parts = (pathlib.Path(__file__).parent / "interesting-projects.gmi").read_text().rstrip().split("\n\n")
links = list(map(Link, parts))

concrete_tags = dict()

for link in links:
    for tag in link.tags:
        tag_parts = list(filter(None, tag.split(":")))
        for i, tag_part in enumerate(tag_parts):
            concrete_tag = tuple(tag_parts[0:i+1])
            concrete_tag_links = concrete_tags.get(concrete_tag, set())
            concrete_tag_links.add(link)
            concrete_tags[concrete_tag] = concrete_tag_links


TARGET_SIZE = 5


def is_undesirable(tag):
    return (
        (tag == ("kind",))
        or (tag == ("coding",))
        or (tag == ("kind", "cli",))
        or (tag == ("kind", "framework",))
        or (tag == ("kind", "gui",))
        or (tag == ("kind", "library",))
        or (tag == ("kind", "service",))
        or (tag == ("kind", "tui",))
        or (tag == ("kind", "desktop-app",))
        or (tag == ("coding", "static-typing",))
        or (tag[0] in ("programmed-in", "uses-storage", "compiles-to",))
    )


chosen_tags = dict()

while concrete_tags:
    concrete_tags_sizes = {concrete_tag: len(links) for concrete_tag, links in concrete_tags.items() if not is_undesirable(concrete_tag)}
    sizes = list(set(concrete_tags_sizes.values()))
    sizes_distance_to_target = sorted(sizes, key=lambda size: abs(size-TARGET_SIZE))
    optimal_size = sizes_distance_to_target[0]

    if optimal_size == 0:
        break

    concrete_tags_of_optimal_size = [concrete_tag for concrete_tag, links in concrete_tags.items() if len(links) == optimal_size and not is_undesirable(concrete_tag)]

    chosen_tag = random.choice(concrete_tags_of_optimal_size)
    chosen_links = concrete_tags[chosen_tag]

    chosen_tags[chosen_tag] = chosen_links

    for concrete_tag, links in concrete_tags.items():
        links = [l for l in links if l not in chosen_links]
        concrete_tags[concrete_tag] = links

print("# Interesting projects")
print()
print("I do not like GitHub stars, and every day there are more projects outside GitHub")
print()

previous_tag = None

for tag in sorted(list(chosen_tags.keys())):
    if previous_tag and len(tag) > 1 and previous_tag[0] != tag[0]:
        print("##", tag[0])
        print()

    print("#" * (len(tag) + 1), " / ".join(tag))
    print()
    for link in chosen_tags[tag]:
        print(link.link)
        print(link.gemtext)
        print(" ".join(link.tags))
        print()

    previous_tag = tag
