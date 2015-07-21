from blending.src.decider.base_decider import BaseDecider
from blending.util.blending_error import blending_status

__author__ = 'DongMin Kim'


class DecideNull(BaseDecider):
    """Not decide, just return chosen atoms.
    """

    def __init__(self, a):
        super(self.__class__, self).__init__(a)

    def blending_decide_impl(self, chosen_atoms, config_base):
        if chosen_atoms is None or len(chosen_atoms) < 2:
            self.last_status = blending_status.NOT_ENOUGH_ATOMS
            return

        # Just return same list.
        self.ret = chosen_atoms
