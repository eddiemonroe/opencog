from blending.src.chooser.choose_null import ChooseNull
from blending.src.chooser.choose_all import ChooseAll
from blending.src.chooser.choose_in_sti_range import ChooseInSTIRange
from blending.util.blending_config import BlendConfig
from blending.util.blending_error import blending_status

__author__ = 'DongMin Kim'


class ChooserFinder(object):
    """Provide chooser instance for user.

    Attributes:
        a: An instance of atomspace.
        last_status: A last status of class.
        choosers: An available atoms chooser list.
        :type a: opencog.atomspace.AtomSpace
        :type last_status: int
        :type choosers: dict[abc.ABCMeta]
    """

    def __init__(self, a):
        self.a = a
        self.last_status = blending_status.UNKNOWN_ERROR

        self.choosers = {
            ChooseNull.__name__: ChooseNull,
            ChooseAll.__name__: ChooseAll,
            ChooseInSTIRange.__name__: ChooseInSTIRange
        }

    def get_chooser(self, config_base):
        self.last_status = blending_status.IN_PROCESS

        chooser = self.choosers.get(
            BlendConfig().get_str(self.a, "atoms-chooser", config_base)
        )
        if chooser is not None:
            self.last_status = blending_status.SUCCESS
            return chooser(self.a)
        else:
            self.last_status = blending_status.PARAMETER_ERROR
            raise UserWarning
