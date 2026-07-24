package soul.view.field.visual.players
{
   import soul.view.field.visual.players.models.*;
   
   public class PlayerModelFactory
   {
      
      public static const classMap:Object = {};
      
      classMap["acolyte"] = Acolyte;
      classMap["acolyte_f"] = AcolyteFemale;
      classMap["berserk"] = Berserk;
      classMap["berserk_f"] = BerserkFemale;
      classMap["believer"] = Believer;
      classMap["believer_f"] = BelieverFemale;
      classMap["rogue"] = Rogue;
      classMap["rogue_f"] = RogueFemale;
      classMap["knight"] = Knight;
      classMap["knight1"] = Knight1;
      classMap["knight_f"] = KnightFemale;
      classMap["sting"] = Sting;
      classMap["sting_f"] = StingFemale;
      classMap["shaman"] = Shaman;
      classMap["shaman_f"] = ShamanFemale;
      classMap["wizard"] = Wizard;
      classMap["wizard_f"] = WizardFemale;
      classMap["smile"] = Smile;
      classMap["smile_f"] = SmileFemale;
      classMap["layered_human"] = LayeredHuman;
      classMap["beholder"] = Beholder;
      classMap["cat1"] = Cat1;
      classMap["darkvil"] = Darkvil;
      classMap["darlac"] = Darlac;
      classMap["darlac_f"] = DarlacFemale;
      classMap["darlac_small"] = DarlacSmall;
      classMap["dermon"] = Dermon;
      classMap["dog"] = Dog;
      classMap["dragonfly"] = Dragonfly;
      classMap["drou"] = Drou;
      classMap["drou_f"] = DrouFemale;
      classMap["drou_small"] = DrouSmall;
      classMap["elf"] = Elf;
      classMap["elf_f"] = ElfFemale;
      classMap["elf_small"] = ElfSmall;
      classMap["fatman1"] = Fatman1;
      classMap["fatman2"] = Fatman2;
      classMap["gorra"] = Gorra;
      classMap["gorra_f"] = GorraFemale;
      classMap["gorra_small"] = GorraSmall;
      classMap["hellhound"] = Hellhound;
      classMap["hellhound_small"] = HellhoundSmall;
      classMap["human"] = Human;
      classMap["human_f"] = HumanFemale;
      classMap["human_small"] = HumanSmall;
      classMap["hunter"] = Hunter;
      classMap["hunter_spirit"] = HunterSpirit;
      classMap["krax"] = Krax;
      classMap["lizard"] = Lizard;
      classMap["lizard_f"] = LizardFemale;
      classMap["lizard_small"] = LizardSmall;
      classMap["maiden1"] = Maiden1;
      classMap["maiden2"] = Maiden2;
      classMap["ogre"] = Ogre;
      classMap["oldman1"] = Oldman1;
      classMap["oldman2"] = Oldman2;
      classMap["panther"] = Panther;
      classMap["panther_f"] = PantherFemale;
      classMap["panther_small"] = PantherSmall;
      classMap["panther_tiny"] = PantherTiny;
      classMap["ratman"] = Ratman;
      classMap["ratman_f"] = RatmanFemale;
      classMap["ratman_small"] = RatmanSmall;
      classMap["settler1"] = Settler1;
      classMap["settler2"] = Settler2;
      classMap["spiker"] = Spiker;
      classMap["shady"] = Shady;
      classMap["slime"] = Slime;
      classMap["skeleton"] = Skeleton;
      classMap["skeleton_small"] = SkeletonSmall;
      classMap["skeletor"] = Skeletor;
      classMap["spark"] = Spark;
      classMap["spark_small"] = SparkSmall;
      classMap["spirit"] = Spirit;
      classMap["spirit_small"] = SpiritSmall;
      classMap["squig"] = Squig;
      classMap["storm"] = Storm;
      classMap["wolf"] = Wolf;
      classMap["wraith"] = Wraith;
      
      public function PlayerModelFactory()
      {
         super();
      }
      
      public static function getClassByVisualId(visualId:String) : Class
      {
         return classMap[visualId] || Contour;
      }
   }
}

